import 'package:snowscape_tracker/commands/base_command.dart';

class LocationCommand extends BaseCommand {
  void getCurrentLocation() {
    locationService.setCurrentLocation();
  }
}
