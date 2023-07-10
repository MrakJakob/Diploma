import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:snowscape_tracker/data/planned_tour.dart';
import 'package:snowscape_tracker/data/recorded_activity.dart';
import 'package:snowscape_tracker/data/rules/matched_rule.dart';

class MapCommand extends BaseCommand {
  void initiateMap(MapboxMapController controller) {
    mapModel.mapController = controller;
  }

  void updateCameraPosition(bg.Location? currentLocation) {
    if (mapModel.mapController == null || currentLocation == null) return;

    var cameraPosition = CameraPosition(
      target: LatLng(
        currentLocation.coords.latitude,
        currentLocation.coords.longitude,
      ),
      zoom: 15.0,
      bearing: currentLocation.coords.heading,
    );

    mapModel.mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  Future<void> updatePolyline(
      List<LatLng> points, String type, MapboxMapController? controller) async {
    MapboxMapController? mapController = controller ?? mapModel.mapController;
    if (mapController == null || points.isEmpty) return;

    var color =
        type == 'recorded' // TODO: this is temporary, change in the future
            ? Color.fromARGB(255, 29, 212, 206).toHexStringRGB()
            : type == 'planned'
                ? '#FF0000'
                : '#000000';
    while (mapController.lineManager == null) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    mapController.lineManager != null
        ? await mapController.addLine(
            LineOptions(
              geometry: points,
              lineColor: color,
              lineWidth: 4.0,
            ),
          )
        : null;
  }

  Future<void> clearMap() async {
    if (mapModel.mapController == null) return;

    await mapModel.mapController!.clearLines();
    await mapModel.mapController!.clearSymbols();
  }

  void showRecordingContainer() {
    mapModel.setSelectedFunctionality = "record";
    mapModel.tourPlanningContainerVisible = false;
    mapModel.recordingContainerVisible = true;
  }

  void hideRecordingContainer() {
    mapModel.setSelectedFunctionality = "none";
    mapModel.recordingContainerVisible = false;
  }

  void showTourPlanningContainer() {
    mapModel.setSelectedFunctionality = "plan";
    mapModel.recordingContainerVisible = false;
    mapModel.tourPlanningContainerVisible = true;
  }

  void hideTourPlanningContainer() {
    mapModel.setSelectedFunctionality = "none";
    mapModel.tourPlanningContainerVisible = false;
  }

  Future updateMarkers(List<Marker> markers) async {
    if (mapModel.mapController == null) return;

    markers.forEach((marker) async {
      await addMarker(marker.point);
    });
  }

  Future addMarker(LatLng marker) async {
    if (mapModel.mapController == null ||
        marker == null ||
        mapModel.mapController!.symbolManager == null) return;
    return await mapModel.mapController?.addSymbol(
      SymbolOptions(
        geometry: marker,
        iconImage: 'assets/dot.png',
        iconSize: 0.02,
      ),
    );
  }

  Future<void> showAlertInfo(Symbol symbol, BuildContext context,
      List<List<MatchedRule>> matchedRulesOnTheSameLocation) async {
    if (symbol.data == null) return;

    int groupIndex = symbol.data!['groupIndex'] ?? 0;
    List<MatchedRule> matchedRules = matchedRulesOnTheSameLocation[groupIndex];

    for (MatchedRule matchedRule in matchedRules) {
      // show alert dialog with the rule info
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(matchedRule.name),
              content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  Text(matchedRule.text),
                ]),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          });
    }
  }

  List<List<MatchedRule>> groupMatchedRulesByLocation(
      List<MatchedRule> matchedRules) {
    List<List<MatchedRule>> matchedRulesOnSameLocation = [[]];
    int groupIndex = 0;

    // Group matched rules by location, so that we can show only one marker
    for (MatchedRule matchedRule in matchedRules) {
      if (matchedRulesOnSameLocation[groupIndex].isEmpty) {
        matchedRulesOnSameLocation[groupIndex].add(matchedRule);
        continue;
      }

      if (matchedRulesOnSameLocation[groupIndex].first.latitude ==
              matchedRule.latitude &&
          matchedRulesOnSameLocation[groupIndex].first.longitude ==
              matchedRule.longitude) {
        matchedRulesOnSameLocation[groupIndex].add(matchedRule);
      } else {
        matchedRulesOnSameLocation.add([matchedRule]);
        groupIndex++;
      }
    }
    return matchedRulesOnSameLocation;
  }

  Future<void>? addWarningMarkers(
      List<MatchedRule> matchedRules, BuildContext context) {
    if (mapModel.mapController == null) return null;

    // if we have more then one matched rule on the same location, we group them,
    // and add only one marker with all the rules
    List<List<MatchedRule>> matchedRulesOnSameLocation =
        groupMatchedRulesByLocation(matchedRules);
    int groupIndex = 0;
    matchedRulesOnSameLocation.forEach((matchedRulesGroup) async {
      await mapModel.mapController?.addSymbol(
          SymbolOptions(
            geometry: LatLng(
              matchedRulesGroup.first.latitude,
              matchedRulesGroup.first.longitude,
            ),
            iconImage: 'assets/warningAlert.png',
            iconSize: 0.2,
          ),
          {
            'groupIndex': groupIndex,
          });
      groupIndex++;
    });

    mapModel.mapController?.onSymbolTapped.add((symbol) {
      print('Symbol tapped: ${symbol.id}');
      showAlertInfo(symbol, context, matchedRulesOnSameLocation);
    });
  }

  Future<void> stopTourPlanning() async {
    await MapCommand().clearMap();
    MapCommand().hideTourPlanningContainer();
  }

  Future<void> showRecordedActivityMarker(
      RecordedActivity recordedActivity) async {
    if (mapModel.mapController == null) return;

    await mapModel.mapController?.addSymbol(
        SymbolOptions(
          geometry: LatLng(
            recordedActivity.points.first.latitude,
            recordedActivity.points.first.longitude,
          ),
          iconOffset: const Offset(23, -35),
          iconImage: 'assets/flag-3-filled.png',
          iconSize: 0.3,
        ),
        {'recordedActivityId': recordedActivity.id});

    mapModel.mapController?.onSymbolTapped.add((symbol) {
      print('Symbol tapped: ${symbol.id}');
      // remove for now, because it is not working properly
      // MapCommand().showRecordedActivity(recordedActivity, true);
    });
  }

  void showRecordedActivity(RecordedActivity recordedActivity, bool removeLayer,
      BuildContext buildContext) async {
    if (mapModel.mapController == null) return;

    if (recordedActivity.points.isEmpty) return;

    mapModel.mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
          recordedActivity.points.first.latitude,
          recordedActivity.points.first.longitude,
        ),
        zoom: 13.0,
      ),
    ));

    if (removeLayer) {
      await mapModel.mapController?.removeLayer('lines');
      await mapModel.mapController?.removeSource('fills');
    }
    // addMarker(recordedActivity.points.first);

    var geometry = {
      "coordinates": recordedActivity.points
          .map((e) => [e.longitude, e.latitude])
          .toList(),
      "type": "LineString"
    };

    final fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": "start",
          "properties": <String, dynamic>{},
          "geometry": geometry,
        }
      ]
    };

    await mapModel.mapController?.addSource(
        "fills",
        GeojsonSourceProperties(
          data: fills,
        ));
    await mapModel.mapController?.addLayer(
        'fills',
        'lines',
        LineLayerProperties(
          lineColor:
              Theme.of(buildContext).secondaryHeaderColor.toHexStringRGB(),
          lineCap: "round",
          lineJoin: "round",
          lineWidth: 4.0,
        ));
  }

  void setExplorePageSelectedItemIndex(int index) {
    mapModel.setExplorePageSelectedItemIndex = index;
  }

  void resetController() {
    mapModel.mapController = null;
  }
}
