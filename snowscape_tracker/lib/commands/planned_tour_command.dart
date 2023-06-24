import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:path/path.dart';
import 'package:snowscape_tracker/commands/app_command.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:snowscape_tracker/data/mapbox_directions_response.dart';
import 'package:snowscape_tracker/data/plannedTourDb/planned_tour_db.dart';
import 'package:snowscape_tracker/data/plannedTourDb/route_point_db.dart';
import 'package:snowscape_tracker/data/planned_tour.dart';
import 'package:snowscape_tracker/data/rules/matched_rule.dart';
import 'package:snowscape_tracker/helpers/directions_handler.dart';
import 'package:snowscape_tracker/helpers/match_rules.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class PlannedTourCommand extends BaseCommand {
  var uuid = const Uuid();

  void _createPlannedTour() {
    plannedTourModel.createPlannedTour();
  }

  void startTourPlanning() {
    if (plannedTourModel.isTourPlanning) return;

    _createPlannedTour();
    plannedTourModel.isTourPlanning = true;
  }

  bool isTourPlanning() {
    return plannedTourModel.isTourPlanning;
  }

  void stopTourPlanning() {
    if (!plannedTourModel.isTourPlanning) return;

    plannedTourModel.isTourPlanning = false;
    plannedTourModel.setPlannedTour = null;
  }

  void addMarker(Marker marker) {
    plannedTourModel.marker = marker;
  }

  List<Marker>? getMarkers() {
    return plannedTourModel.markers;
  }

  Marker getLastMarker() {
    return plannedTourModel.lastMarker;
  }

  // set the whole route
  void setRoute(List<LatLng> route) {
    plannedTourModel.setRoute = route;
  }

  // get the whole route
  List<LatLng>? getRoute() {
    return plannedTourModel.route;
  }

  // add to the route
  void addToRoute(List<LatLng> route) {
    plannedTourModel.addRoute(route);
  }

  void updateRoute(MapboxDirectionsResponse response) {
    if (response.route.isEmpty) return;
    Marker lastAddedMarker = plannedTourModel.lastMarker;

    double duration = plannedTourModel.duration + response.duration;
    double distance = plannedTourModel.distance + response.distance;

    lastAddedMarker.distanceAtMarker = distance;
    lastAddedMarker.durationAtMarker = duration;

    addToRoute(response.route);
    setDuration(duration);
    setDistance(distance);
  }

  void getDuration() {
    plannedTourModel.duration;
  }

  void setDuration(double duration) {
    plannedTourModel.setDuration = duration;
  }

  void getDistance() {
    plannedTourModel.distance;
  }

  void setDistance(double distance) {
    plannedTourModel.setDistance = distance;
  }

  Future<bool> undo() async {
    if (plannedTourModel.markers == null || plannedTourModel.markers.isEmpty) {
      return true;
    }

    // remove the last marker
    plannedTourModel.markers.removeLast();

    if (plannedTourModel.markers.isEmpty) {
      // if there are no more markers, there is no more route
      plannedTourModel.isTourPlanning = false;
      return true;
    }
    // remove the last added route to the marker we just removed
    await plannedTourModel.removeLastRoute();

    // set the new duration and distance, to be the last marker's duration and distance
    plannedTourModel.setDuration = plannedTourModel.lastMarker.durationAtMarker;
    plannedTourModel.setDistance = plannedTourModel.lastMarker.distanceAtMarker;
    return false;
  }

  Future<void> handleRouteUpdate(LatLng coordinates) async {
    if (plannedTourModel.drawStraightLine) {
      // draw a straight line
      MapboxDirectionsResponse response = MapboxDirectionsResponse();
      List<LatLng>? route = PlannedTourCommand().getRoute();
      if (route != null && route.isNotEmpty) {
        // if the route is empty, we need to retrieve the starting marker and add it to the route
        // because this means that the user is adding the second marker to the map while using straight line mode
        LatLng lastMarkerCoordinates =
            PlannedTourCommand().getLastMarker().point;
        response.route.add(lastMarkerCoordinates);
      }
      Marker marker = Marker("", coordinates, 0.0, 0.0);
      PlannedTourCommand().addMarker(marker);
      // TODO: calculate distance between markers, duration, altitude gain, etc.
      response.route.add(coordinates);

      PlannedTourCommand().updateRoute(response);
      return;
    } else {
      // draw the route
      // if the user does not want to draw a straight line between markers, we need to make an api call to get the route between the last marker and the current marker
      LatLng lastMarkerCoordinates = PlannedTourCommand().getLastMarker().point;
      MapboxDirectionsResponse response = await directionsApiResponseModified(
          lastMarkerCoordinates, coordinates);

      // debugPrint("response: $response");
      Marker marker = Marker("", coordinates, 0.0, 0.0);
      PlannedTourCommand().addMarker(marker);
      PlannedTourCommand().updateRoute(response);
      // debugPrint("draw route");
      return;
    }
  }

  void setDrawStraightLine(bool status) {
    plannedTourModel.setDrawStraightLine = status;
  }

  generateRoute() async {
    plannedTourModel.setLoadingPathData = true;
    // int totalElevation =
    //     await arcGISService.getElevationGain(plannedTourModel.route);
    int totalElevation =
        await mapBoxService.getElevationGain(plannedTourModel.route);
    plannedTourModel.setTotalElevationGain = totalElevation;
    plannedTourModel.setLoadingPathData = false;

    List<MatchedRule> matchedRules =
        await matchRules(plannedTourModel.contextPoints, "planned_tour");

    debugPrint("matched rules: $matchedRules");

    if (matchedRules.isNotEmpty) {
      plannedTourModel.setMatchedRules = matchedRules;
    }
  }

  TextEditingController plannedTourNameController() {
    return plannedTourModel.plannedTourNameController;
  }

  Future<int> savePlannedTour() async {
    if (!plannedTourModel.isTourPlanning) return 0;

    Database db = await openDatabase(
      join(await getDatabasesPath(), 'rules_database.db'),
    );

    PlannedTour plannedTour = plannedTourModel.plannedTour!;
    // if the tour already exists, we need to update it
    var plannedTourId = plannedTour.id ?? uuid.v4();
    if (plannedTour.id != null) {
      // if the tour already exists, we are editing it, so we need to delete the old one
      await db.delete(
        'markers',
        where: "plannedTourId = ?",
        whereArgs: [plannedTour.id],
      );
      await db.delete(
        'route_points',
        where: "plannedTourId = ?",
        whereArgs: [plannedTour.id],
      );
      await db.delete(
        'matched_rule',
        where: "plannedTourId = ?",
        whereArgs: [plannedTour.id],
      );
    }
    PlannedTourDb plannedTourDb = PlannedTourDb(
      id: plannedTourId,
      tourName: plannedTourModel.plannedTourNameController.text.trim(),
      distance: plannedTour.distance,
      duration: plannedTour.duration,
      totalElevationGain: plannedTour.totalElevationGain,
    );
    List<Marker> markers = plannedTour.markers;
    List<LatLng> route = plannedTour.route;
    List<MatchedRule> matchedRules = plannedTour.matchedRules!;

    for (var marker in markers) {
      // we need to set the plannedTourId of the marker to the plannedTourId of the tour, so we can reference it later when we want to load the planned tour
      marker.plannedTourId = plannedTourId;
      marker.id = uuid.v4();
      await db.insert(
        'markers',
        marker.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    for (var point in route) {
      RoutePointDb routePointDb = RoutePointDb(uuid.v4(), plannedTourId, point);
      await db.insert(
        'route_points',
        routePointDb.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    for (var matchedRule in matchedRules) {
      matchedRule.id = uuid.v4();
      matchedRule.plannedTourId = plannedTourId;
      await db.insert(
        'matched_rule',
        matchedRule.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return await db.insert(
      'planned_tours',
      plannedTourDb.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PlannedTour>> getPlannedToursFromDatabase() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'rules_database.db'),
      version: 1,
    );

    final List<Map<String, dynamic>> maps =
        await database.query('planned_tours');

    final List<Map<String, dynamic>> markers = await database.query('markers');

    List<Marker> markersList = List.generate(markers.length, (i) {
      return Marker.fromMap(markers[i]);
    });

    final List<Map<String, dynamic>> routePoints =
        await database.query('route_points');

    List<RoutePointDb> routePointsList = List.generate(routePoints.length, (i) {
      return RoutePointDb.fromMap(routePoints[i]);
    });

    final List<Map<String, dynamic>> matchedRulesMaps =
        await database.query('matched_rule');

    List<MatchedRule> matchedRulesList =
        List.generate(matchedRulesMaps.length, (i) {
      return MatchedRule.fromMap(matchedRulesMaps[i]);
    });

    return List.generate(maps.length, (i) {
      PlannedTourDb plannedTourDb = PlannedTourDb.fromMap(maps[i]);

      PlannedTour plannedTour = PlannedTour(
        id: plannedTourDb.id,
      );

      plannedTour.tourName = plannedTourDb.tourName != ""
          ? plannedTourDb.tourName
          : "Planned Tour ${plannedTourDb.id}";
      plannedTour.distance = plannedTourDb.distance;
      plannedTour.duration = plannedTourDb.duration;
      plannedTour.totalElevationGain = plannedTourDb.totalElevationGain;

      plannedTour.markers = markersList
          .where((marker) => marker.plannedTourId == plannedTourDb.id)
          .toList();

      List<RoutePointDb> filtered = routePointsList
          .where((routePoint) => routePoint.plannedTourId == plannedTourDb.id)
          .toList();

      plannedTour.route =
          filtered.map((routePoint) => routePoint.point).toList();

      plannedTour.matchedRules = matchedRulesList
          .where((matchedRule) => matchedRule.plannedTourId == plannedTourDb.id)
          .toList();

      return plannedTour;
    });
  }

  Future<void> loadSavedTourToMap(PlannedTour plannedTour) async {
    AppCommand().switchMainPage(0);
    startTourPlanning();
    plannedTourModel.setId = plannedTour.id;
    plannedTourModel.setDrawStraightLine = false;
    plannedTourModel.setTourName = plannedTour.tourName;
    plannedTourModel.setDuration = plannedTour.duration;
    plannedTourModel.setDistance = plannedTour.distance;
    plannedTourModel.setTotalElevationGain = plannedTour.totalElevationGain;
    plannedTourModel.setMarkers = plannedTour.markers;
    plannedTourModel.setRoute = plannedTour.route;
    plannedTourModel.setMatchedRules = plannedTour.matchedRules ?? [];
    plannedTourModel.setLoadingPathData = false;
    MapCommand().showTourPlanningContainer();
  }
}
