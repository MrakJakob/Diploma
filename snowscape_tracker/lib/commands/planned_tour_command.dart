import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:snowscape_tracker/data/mapbox_directions_response.dart';
import 'package:snowscape_tracker/data/planned_tour.dart';
import 'package:snowscape_tracker/data/rules/matched_rule.dart';
import 'package:snowscape_tracker/helpers/directions_handler.dart';
import 'package:snowscape_tracker/helpers/match_rules.dart';

class PlannedTourCommand extends BaseCommand {
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
    plannedTourModel.createPlannedTour();
  }

  void addMarker(Marker marker) {
    plannedTourModel.marker = marker;
  }

  List<Marker> getMarkers() {
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
  List<LatLng> getRoute() {
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
    plannedTourModel.removeLastRoute();

    // set the new duration and distance, to be the last marker's duration and distance
    plannedTourModel.setDuration = plannedTourModel.lastMarker.durationAtMarker;
    plannedTourModel.setDistance = plannedTourModel.lastMarker.distanceAtMarker;
    return false;
  }

  Future<void> handleRouteUpdate(LatLng coordinates) async {
    if (plannedTourModel.drawStraightLine) {
      // draw a straight line
      MapboxDirectionsResponse response = MapboxDirectionsResponse();
      if (PlannedTourCommand().getRoute().isEmpty) {
        // if the route is empty, we need to retrieve the starting marker and add it to the route
        // because this means that the user is adding the second marker to the map while using straight line mode
        LatLng lastMarkerCoordinates =
            PlannedTourCommand().getLastMarker().point;
        response.route.add(lastMarkerCoordinates);
      }
      Marker marker = Marker(coordinates, 0.0, 0.0);
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
      Marker marker = Marker(coordinates, 0.0, 0.0);
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
}
