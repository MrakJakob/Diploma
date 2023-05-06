import "package:flutter/material.dart";
import "package:mapbox_gl/mapbox_gl.dart";
import "package:snowscape_tracker/data/RecordActivity.dart";

class RecordActivityModel extends ChangeNotifier {
  bool _isRecording = false;
  RecordedActivity? _recordedActivity;

  set isRecording(bool status) {
    _isRecording = status;
    notifyListeners();
  }

  bool get isRecording => _isRecording;

  void createRecordedActivity() {
    _recordedActivity = RecordedActivity(startTime: DateTime.now());
  }

  void endRecordedActivity() {
    _recordedActivity?.endTime = DateTime.now();
  }

  get recordedActivity => _recordedActivity;

  set setPoints(List<LatLng> points) {
    _recordedActivity?.points = points;
    notifyListeners();
  }

  set addPoint(LatLng point) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // addPostFrameCallback is used to avoid the error "setState() or markNeedsBuild() called during build"
      // reference: https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
      _recordedActivity?.points.add(point);
      notifyListeners();
    });
  }

  get points => _recordedActivity?.points;

  set setDistance(double distance) {
    if (_recordedActivity != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recordedActivity?.distance = distance;
        notifyListeners();
      });
    }
  }

  get distance => _recordedActivity != null ? _recordedActivity?.distance : 0.0;

  set setAverageSpeed(double averageSpeed) {
    if (_recordedActivity != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recordedActivity?.averageSpeed = averageSpeed;
        notifyListeners();
      });
    }
  }

  get averageSpeed =>
      _recordedActivity != null ? _recordedActivity?.averageSpeed : 0.0;

  // set start time after we recover the activity from shared preferences
  set startTime(DateTime startTime) {
    _recordedActivity?.startTime = startTime;
    notifyListeners();
  }

  DateTime getStartTime() {
    return _recordedActivity?.startTime ?? DateTime.now();
  }

  set duration(int durationSeconds) {
    _recordedActivity?.duration = durationSeconds;
    notifyListeners();
  }

  set incrementDuration(int durationSeconds) {
    _recordedActivity?.duration += durationSeconds;
    notifyListeners();
  }

  get getDuration => _recordedActivity?.duration ?? 0;
}
