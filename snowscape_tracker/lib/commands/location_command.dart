import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class LocationCommand extends BaseCommand {
  void setCurrentLocation(bg.Location location) {
    locationModel.currentLocation = location;
  }

  Future<void> getCurrentLocation() async {
    await locationService?.setCurrentLocation();
  }

  void changeTrackingPace() {
    locationService?.changePace();
  }
}
