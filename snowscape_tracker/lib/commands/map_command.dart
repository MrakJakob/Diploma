import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:snowscape_tracker/data/planned_tour.dart';

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

  // void removeLastMarker() {
  //   mapModel.mapController?.addSource("s", GeoJsonSource(data: null));
  // }

  void resetController() {
    mapModel.mapController = null;
  }
}
