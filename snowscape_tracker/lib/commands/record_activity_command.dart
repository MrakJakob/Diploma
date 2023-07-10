import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:snowscape_tracker/data/recording_status.dart';
import 'package:snowscape_tracker/utils/snack_bar.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:snowscape_tracker/utils/user_preferences.dart';

class RecordActivityCommand extends BaseCommand {
  void startRecording() {
    // recordActivityModel.isRecording = true;
    recordActivityModel.recordingStatus = RecordingStatus.recording;
    recordActivityModel.createRecordedActivity();
    UserPreferences.setActivityStartTime(recordActivityModel
        .getStartTime()); // save the start time of the recording activity to shared preferences
    // UserPreferences.setRecording(true); // and set recording status to true
    UserPreferences.setRecording(RecordingStatus.recording);
  }

  void stopRecording() async {
    recordActivityModel.recordingStatus = RecordingStatus.paused;

    // recordActivityModel.endRecordedActivity();
    await UserPreferences.setRecording(RecordingStatus.paused);
  }

  bool recordingStatus() {
    return recordActivityModel.getRecordingStatus ==
        RecordingStatus.recording; // return the recording status
  }

  void resumeRecording() async {
    recordActivityModel.recordingStatus = RecordingStatus.recording;

    await UserPreferences.setRecording(RecordingStatus.recording);
  }

  void finishRecording() {
    // show the dialog to save the activity

    // recordActivityModel.recordingStatus = RecordingStatus.idle;
    // UserPreferences.setRecording(RecordingStatus.idle);
  }

  Future<bool> saveRecordedActivity() async {
    // save the recorded activity to firestore
    recordActivityModel.endRecordedActivity();
    recordActivityModel.tourName =
        recordActivityModel.tourNameController.text ?? "Tour";
    recordActivityModel.description =
        recordActivityModel.tourDescriptionController.text ?? "No description";

    bool succes = await recordedActivityService
        .saveRecordedActivity(recordActivityModel.recordedActivity);

    if (succes) {
      recordActivityModel.recordingStatus = RecordingStatus.idle;
      UserPreferences.setRecording(RecordingStatus.idle);
      mapModel.recordingContainerVisible = false;
      recordActivityModel.setRecordedActivity = null;
      SnackBarWidget.show('Activity saved successfully', Colors.green);
    }

    return succes;
  }

  Future<void> endRecordedActivity() async {
    await UserPreferences.setRecording(RecordingStatus.idle);
    recordActivityModel.recordingStatus = RecordingStatus.idle;
    mapModel.recordingContainerVisible = false;
    recordActivityModel.setRecordedActivity = null;
    return;
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

  Future<void> saveElapsedTimeToSharedPreferences() async {
    if (recordActivityModel.getRecordingStatus == RecordingStatus.recording) {
      // we have to save the timestamp of when the app went to background
      // so that we can later calculate the elapsed time in background
      await UserPreferences.backgroundTimestamp(
          DateTime.now().millisecondsSinceEpoch);
    }

    return await UserPreferences.setActivityElapsedTime(
        recordActivityModel.getDuration);
  }

  Future<List<LatLng>?> recoverRecordedActivityFromSharedPreferences() async {
    var pathCoordinates = await UserPreferences.getPathCoordinates();
    if (pathCoordinates.isNotEmpty) {
      // if we have a path saved in shared preferences, we need to recover the activity

      if (recordActivityModel.recordedActivity == null) {
        // if we don't have an instance of recorded activity, we create an empty one
        recordActivityModel.createRecordedActivity();
      }
      // recordActivityModel.isRecording = UserPreferences.getRecording();
      recordActivityModel.recordingStatus =
          UserPreferences.getRecordingStatus();

      recordActivityModel.setPoints =
          pathCoordinates; // we set the points to the recovered path so we can display it on the map
      mapModel.recordingContainerVisible =
          true; // we set this to true so that the recording container is visible when we recover the activity
      recordActivityModel.startTime =
          await UserPreferences.getActivityStartTime();

      if (recordActivityModel.getRecordingStatus == RecordingStatus.recording) {
        // if the recording was in progress when the app went to background, we need to calculate the elapsed time
        var timeInBackground = await UserPreferences.getBackgroundTimestamp();
        timeInBackground = DateTime.now().millisecondsSinceEpoch -
            timeInBackground; // we calculate the elapsed time in background

        var timeElapsedBeforeBackground =
            await UserPreferences.getActivityElapsedTime();

        recordActivityModel.duration =
            timeElapsedBeforeBackground + (timeInBackground / 1000).round();
      } else {
        // we are recovering a paused activity, so we just set the duration to the one saved in shared preferences
        recordActivityModel.duration =
            await UserPreferences.getActivityElapsedTime();
      }
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

  TextEditingController tourNameController() {
    return recordActivityModel.tourNameController;
  }

  TextEditingController tourDescriptionController() {
    return recordActivityModel.tourDescriptionController;
  }

  void setDifficulty(int difficulty) {
    recordActivityModel.difficulty = difficulty;
  }

  void setIsPublic(bool isPublic) {
    recordActivityModel.isPublic = isPublic;
  }
}
