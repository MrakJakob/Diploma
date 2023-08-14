import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/commands/location_command.dart';
import 'package:snowscape_tracker/commands/record_activity_command.dart';
import 'package:snowscape_tracker/data/recording_status.dart';
import 'package:snowscape_tracker/utils/snack_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';

class LocationService {
  LocationService() {
    // Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      // debugPrint('[location] - $location');
      LocationCommand().setCurrentLocation(location);
      if (UserPreferences.getRecordingStatus() == RecordingStatus.recording) {
        // Save the point to shared preferences in case the app is closed
        UserPreferences.addPathCoordinate(
            LatLng(location.coords.latitude, location.coords.longitude));
      }
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
            debug: false,
            logLevel: bg.Config.LOG_LEVEL_ERROR))
        .then((bg.State state) async {
      if (!state.enabled) {
        var status = await Permission.location.status;
        // we check if the location permission is granted
        if (status.isGranted) {
          ////
          // 3.  Start the plugin.
          //
          bg.BackgroundGeolocation.start();
        }
      }
    });
  }

  Future<void> setCurrentLocation() async {
    var permissionStatus = await Permission.location.status;

    if (permissionStatus.isDenied) {
      await Permission.location.request();

      if (await Permission.location.status.isDenied) {
        await SnackBarWidget.show(
            'Location permission is required to use this feature', null);
        await Future.delayed(const Duration(seconds: 2));
        await openAppSettings();
      }
    }

    if (permissionStatus.isGranted) {
      await bg.BackgroundGeolocation.getCurrentPosition(
        persist: false, // <-- do not persist this location
        desiredAccuracy: 0, // <-- desire best possible accuracy
        timeout: 30000, // <-- wait 30s before giving up.
        samples: 3, // <-- sample 3 location before selecting best.
      ).then((bg.Location location) {
        LocationCommand().setCurrentLocation(location);
      }).catchError((error) {
        debugPrint('[getCurrentPosition] ERROR: $error');
      });
    }
  }

  void changePace() async {
    await bg.BackgroundGeolocation.start();
    // var state = await bg.BackgroundGeolocation.state;
    var status = RecordActivityCommand().recordingStatus();
    await bg.BackgroundGeolocation.changePace(status);
  }
}
