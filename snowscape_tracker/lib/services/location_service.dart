import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:snowscape_tracker/data/recording_status.dart';
import 'package:snowscape_tracker/utils/snack_bar.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {

  Future<void> setCurrentLocation() async {
    var permissionStatus = await Permission.location.status;

    if (permissionStatus.isDenied) {
      await Permission.location.request();

      if (await Permission.location.status.isDenied) {
        await Permission.locationWhenInUse.request();

        if (await Permission.locationWhenInUse.status.isDenied) {
          await SnackBarWidget.show(
              'Location permission is required to use this feature', null);
          await Future.delayed(Duration(seconds: 2));

          await openAppSettings();
        }
      }
    }

    if (permissionStatus.isGranted) {
      await bg.BackgroundGeolocation.getCurrentPosition(
        persist: false, // <-- do not persist this location
        desiredAccuracy: 0, // <-- desire best possible accuracy
        timeout: 30000, // <-- wait 30s before giving up.
        samples: 3, // <-- sample 3 location before selecting best.
      ).then((bg.Location location) {
        debugPrint('[getCurrentPosition] - $location');
        // locationModel.currentLocation = location;
      }).catchError((error) {
        debugPrint('[getCurrentPosition] ERROR: $error');
      });
    }
  }

  void changePace() async {
    await bg.BackgroundGeolocation.start();
    var state = await bg.BackgroundGeolocation.state;
    // await bg.BackgroundGeolocation.changePace(
        // recordActivityModel.getRecordingStatus == RecordingStatus.recording);
  }
}
