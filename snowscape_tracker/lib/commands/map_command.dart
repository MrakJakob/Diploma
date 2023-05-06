import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

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

  Future<void> updatePolyline(List<LatLng> points) async {
    if (mapModel.mapController == null || points.isEmpty) return;

    await mapModel.mapController!.addLine(
      LineOptions(
        geometry: points,
        lineColor: '#86D7FB',
        lineWidth: 4.0,
      ),
    );
  }

  void showRecordingContainer() {
    mapModel.recordingContainerVisible = true;
  }

  void hideRecordingContainer() {
    mapModel.recordingContainerVisible = false;
  }

  void resetController() {
    mapModel.mapController = null;
  }
}
