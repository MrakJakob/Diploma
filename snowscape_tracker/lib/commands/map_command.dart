import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:path/path.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:snowscape_tracker/data/planned_tour.dart';
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

  Future<void> updatePolyline(List<LatLng> points, String type) async {
    if (mapModel.mapController == null || points.isEmpty) return;

    var color =
        type == 'recorded' // TODO: this is temporary, change in the future
            ? '#86D7FB'
            : type == 'planned'
                ? '#FF0000'
                : '#000000';

    if (mapModel.mapController?.lineManager == null ||
        mapModel.mapController?.addLine == null) return;
    await mapModel.mapController?.addLine(
      LineOptions(
        geometry: points,
        lineColor: color,
        lineWidth: 4.0,
      ),
    );
  }

  Future<void> clearMap() async {
    if (mapModel.mapController == null) return;

    await mapModel.mapController!.clearLines();
    await mapModel.mapController!.clearSymbols();
  }

  void showRecordingContainer() {
    mapModel.tourPlanningContainerVisible = false;
    mapModel.recordingContainerVisible = true;
  }

  void hideRecordingContainer() {
    mapModel.recordingContainerVisible = false;
  }

  void showTourPlanningContainer() {
    mapModel.recordingContainerVisible = false;
    mapModel.tourPlanningContainerVisible = true;
  }

  void hideTourPlanningContainer() {
    mapModel.tourPlanningContainerVisible = false;
  }

  Future updateMarkers(List<Marker> markers) async {
    if (mapModel.mapController == null) return;

    markers.forEach((marker) async {
      await addMarker(marker.point);
    });
  }

  Future addMarker(LatLng marker) async {
    return await mapModel.mapController?.addSymbol(
      SymbolOptions(
        geometry: marker,
        iconImage: 'assets/dot.png',
        iconSize: 0.02,
      ),
    );
  }

  Future<void> showAlertInfo(Symbol symbol, BuildContext context) async {
    if (symbol.data == null) return;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(symbol.data!['name'] ?? ''),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                Text(symbol.data!['text'] ?? ''),
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

  Future<void>? addWarningMarkers(
      List<MatchedRule> matchedRules, BuildContext context) {
    if (mapModel.mapController == null) return null;

    matchedRules.forEach((matchedRule) async {
      await mapModel.mapController?.addSymbol(
        SymbolOptions(
          geometry: LatLng(
            matchedRule.latitude,
            matchedRule.longitude,
          ),
          iconImage: 'assets/warningAlert.png',
          iconSize: 0.2,
        ),
        matchedRule.toMap(),
      );
    });
    mapModel.mapController?.onSymbolTapped.add((symbol) {
      print('Symbol tapped: ${symbol.id}');
      showAlertInfo(symbol, context);
    });
  }

  void resetController() {
    mapModel.mapController = null;
  }
}
