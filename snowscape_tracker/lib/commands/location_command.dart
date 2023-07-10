import 'package:snowscape_tracker/commands/base_command.dart';

class LocationCommand extends BaseCommand {
  Future<void> getCurrentLocation() async {
    await locationService.setCurrentLocation();
  }

  void changeTrackingPace() {
    locationService.changePace();
  }
}
