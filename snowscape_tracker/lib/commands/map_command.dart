import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class MapCommand extends BaseCommand {
  void initiateMap(MapboxMapController controller) {
    mapModel.mapController = controller;
  }

  void updateCameraPosition(bg.Location? currentLocation) {
    if (mapModel.mapController == null ||
        mapModel.mapController?.lineManager == null ||
        currentLocation == null) return;
    mapModel.mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentLocation.coords.latitude,
            currentLocation.coords.longitude,
          ),
          zoom: 15.0,
          bearing: currentLocation.coords.heading,
        ),
      ),
    );
  }

  void resetController() {
    mapModel.mapController = null;
  }
}
