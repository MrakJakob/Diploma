import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:snowscape_tracker/commands/base_command.dart';

class LocationService extends BaseCommand {
  LocationService() {
    // Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      debugPrint('[location] - $location');
      locationModel.currentLocation = location;
    });

    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      debugPrint('[motionchange] - $location');
      // locationModel.currentLocation = location;
    });

    // Fired whenever the state of location-services changes.  Always fired at boot
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      debugPrint('[providerchange] - $event');
    });

    ////
    // 2.  Configure the plugin
    //
    bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            stopOnTerminate: false,
            startOnBoot: true,
            debug: true,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE))
        .then((bg.State state) {
      if (!state.enabled) {
        ////
        // 3.  Start the plugin.
        //
        bg.BackgroundGeolocation.start();
      }
    });
  }

  void setCurrentLocation() {
    bg.BackgroundGeolocation.getCurrentPosition(
      persist: false, // <-- do not persist this location
      desiredAccuracy: 0, // <-- desire best possible accuracy
      timeout: 30000, // <-- wait 30s before giving up.
      samples: 3, // <-- sample 3 location before selecting best.
    ).then((bg.Location location) {
      debugPrint('[getCurrentPosition] - $location');
      locationModel.currentLocation = location;
    }).catchError((error) {
      debugPrint('[getCurrentPosition] ERROR: $error');
    });
  }
}
