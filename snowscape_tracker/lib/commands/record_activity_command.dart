import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'dart:math' show cos, sqrt, asin;
import 'package:snowscape_tracker/utils/user_preferences.dart';

class RecordActivityCommand extends BaseCommand {
  void startRecording() {
    recordActivityModel.isRecording = true;
    recordActivityModel.createRecordedActivity();
    UserPreferences.setActivityStartTime(recordActivityModel
        .getStartTime()); // save the start time of the recording activity to shared preferences
    UserPreferences.setRecording(true); // and set recording status to true
  }

  void stopRecording() async {
    recordActivityModel.isRecording = false;
    recordActivityModel.endRecordedActivity();
    await UserPreferences.setRecording(false);
  }

  double calculateDistanceBetweenPoints(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double calculateDistance(List<LatLng> points) {
    double distance = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      distance += calculateDistanceBetweenPoints(points[i].latitude,
          points[i].longitude, points[i + 1].latitude, points[i + 1].longitude);
    }
    return distance;
  }

  void addPointToRecordedActivity(bg.Location currentLocation) {
    final point = LatLng(
        currentLocation.coords.latitude, currentLocation.coords.longitude);

    recordActivityModel.addPoint = point;

    // Update/set distance
    recordActivityModel.setDistance =
        calculateDistance(recordActivityModel.points);

    // Update/set average speed
    recordActivityModel.setAverageSpeed =
        recordActivityModel.distance / (recordActivityModel.getDuration / 3600);
  }

  void saveRecordedActivityToSharedPreferences() async {
    var pathCoordinates = await recordActivityModel.points;
    var startTime = recordActivityModel.getStartTime();

    UserPreferences.setPathCoordinates(pathCoordinates);
    UserPreferences.setActivityStartTime(startTime);
  }

  Future<List<LatLng>?> recoverRecordedActivityFromSharedPreferences() async {
    var pathCoordinates = await UserPreferences.getPathCoordinates();
    if (pathCoordinates.isNotEmpty) {
      // if we have a path saved in shared preferences, we need to recover the activity

      if (recordActivityModel.recordedActivity == null) {
        // if we don't have an instance of recorded activity, we create an empty one
        recordActivityModel.createRecordedActivity();
      }
      recordActivityModel.isRecording = UserPreferences.getRecording();
      recordActivityModel.setPoints =
          pathCoordinates; // we set the points to the recovered path so we can display it on the map
      mapModel.recordingContainerVisible =
          true; // we set this to true so that the recording container is visible when we recover the activity
      recordActivityModel.startTime =
          await UserPreferences.getActivityStartTime();
      return pathCoordinates;
    } else {
      return null;
    }
  }

  void setActivityDuration(int durationInSeconds) {
    recordActivityModel.duration = durationInSeconds;
  }

  // this is used to increment the duration of the activity by 1 second when the user is recording
  void incrementActivityDuration() {
    recordActivityModel.incrementDuration = 1;
  }
}
