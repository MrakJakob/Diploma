import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';

class LocationService extends BaseCommand {
  LocationService() {
    // Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      debugPrint('[location] - $location');
      locationModel.currentLocation = location;
      if (UserPreferences.getRecording()) {
        // Save the point to shared preferences in case the app is closed
        UserPreferences.addPathCoordinate(
            LatLng(location.coords.latitude, location.coords.longitude));
      }
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
            distanceFilter: 5.0,
            enableHeadless: true,
            stopOnTerminate: false,
            startOnBoot: true,
            debug: true,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE))
        .then((bg.State state) {
      if (!state.enabled) {
        // TODO: Check if permission were given before starting the plugin
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

  void changePace() {
    bg.BackgroundGeolocation.changePace(recordActivityModel.isRecording);
  }
}
