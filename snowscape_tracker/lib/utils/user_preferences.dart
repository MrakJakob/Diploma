import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snowscape_tracker/data/recording_status.dart';

class UserPreferences {
  static SharedPreferences? _preferences;

  // static const String _isRecording = 'isRecording';
  static const String _userUid = 'userUid';
  static const String _recordingStatus = 'recordingStatus';
  static const String _pathLongitudeCoordinates = 'pathLongitudeCoordinates';
  static const String _pathLatitudeCoordinates = 'pathLatitudeCoordinates';
  static const String _activityStartTime = 'activityStartTime';
  static const String _activityElapsedTimeInSeconds =
      'activityElapsedTimeInSeconds';
  static const String _backgroundTimestampMiliseconds =
      'backgroundTimestampMiliseconds';
  static const String _isFirstLoad = 'isFirstLoad';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static bool isFirstLoad() => _preferences!.getBool(_isFirstLoad) ?? true;

  static Future setFirstLoad(bool isFirstLoad) async =>
      await _preferences!.setBool(_isFirstLoad, isFirstLoad);

  static Future setUserUid(String? userUid) async {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      await init();
    }
    await _preferences!.setString(_userUid, userUid ?? '');
  }

  static String getUserUid() => _preferences!.getString(_userUid) ?? '';

  static Future setRecording(RecordingStatus recordingStatus) async {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      await init();
    }
    await _preferences!
        .setString(_recordingStatus, recordingStatus.recordingStatus);
    // await _preferences!.setBool(_isRecording, isRecording);
  }

  // static bool getRecording() => _preferences!.getBool(_isRecording) ?? false;
  static RecordingStatus getRecordingStatus() {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      init();
    }
    var recordingStatus = _preferences!.getString(_recordingStatus);
    switch (recordingStatus) {
      case 'idle':
        return RecordingStatus.idle;
      case 'recording':
        return RecordingStatus.recording;
      case 'paused':
        return RecordingStatus.paused;
      default:
        return RecordingStatus.idle;
    }
  }

  // We have to set the path coordinates as a list of seperate strings (longitude, latitude) because shared preferences doesn't support lists of objects
  static Future _setPathLongitudeCoordinates(
          List<String> pathLongitudeCoordinates) async =>
      await _preferences!
          .setStringList(_pathLongitudeCoordinates, pathLongitudeCoordinates);

  static Future _setPathLatitudeCoordinates(
          List<String> pathLatitudeCoordinates) async =>
      await _preferences!
          .setStringList(_pathLatitudeCoordinates, pathLatitudeCoordinates);

  static Future<List<String>> getPathLongitudeCoordinates() async {
    try {
      return _preferences?.getStringList(_pathLongitudeCoordinates) ?? [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<List<String>> getPathLatitudeCoordinates() async {
    try {
      return _preferences?.getStringList(_pathLatitudeCoordinates) ?? [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static Future setPathCoordinates(List<LatLng> pathCoordinates) async {
    // we have to save the path coordinates as a list of strings so we can save them to shared preferences
    // we will convert the list of LatLng objects to 2 lists of strings, one for longitude and one for latitude
    List<String> pathLongitudeCoordinates = [];
    List<String> pathLatitudeCoordinates = [];

    pathCoordinates.map((e) {
      pathLongitudeCoordinates.add(e.longitude.toString());
      pathLatitudeCoordinates.add(e.latitude.toString());
    });

    _preferences!
        .setStringList(_pathLatitudeCoordinates, pathLatitudeCoordinates);
    _preferences!
        .setStringList(_pathLongitudeCoordinates, pathLongitudeCoordinates);
  }

  static Future addPathCoordinate(LatLng pathCoordinate) async {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      await init();
    }

    List<String> pathLongitudeCoordinates = await getPathLongitudeCoordinates();
    List<String> pathLatitudeCoordinates = await getPathLatitudeCoordinates();

    var latitude = pathCoordinate.latitude.toString();
    var longitude = pathCoordinate.longitude.toString();

    pathLatitudeCoordinates.add(latitude);
    pathLongitudeCoordinates.add(longitude);

    _setPathLatitudeCoordinates(pathLatitudeCoordinates);
    _setPathLongitudeCoordinates(pathLongitudeCoordinates);
  }

  static Future<List<LatLng>> getPathCoordinates() async {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      await init();
    }

    List<String> pathLatitudeCoordinates = await getPathLatitudeCoordinates();
    List<String> pathLongitudeCoordinates = await getPathLongitudeCoordinates();

    List<LatLng> pathCoordinates = [];

    for (int i = 0; i < pathLongitudeCoordinates.length; i++) {
      // we combine the longitude and latitude coordinates into a list of LatLng objects
      pathCoordinates.add(LatLng(double.parse(pathLatitudeCoordinates[i]),
          double.parse(pathLongitudeCoordinates[i])));
    }
    return pathCoordinates;
  }

  static setActivityStartTime(DateTime startTime) async {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      await init();
    }
    await _preferences!
        .setInt(_activityStartTime, startTime.millisecondsSinceEpoch);
  }

  static Future<DateTime> getActivityStartTime() async =>
      DateTime.fromMillisecondsSinceEpoch(
          _preferences!.getInt(_activityStartTime) ?? 0);

  static setActivityElapsedTime(int elapsedTimeInSeconds) async {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      init();
    }
    return await _preferences!
        .setInt(_activityElapsedTimeInSeconds, elapsedTimeInSeconds);
  }

  static Future<int> getActivityElapsedTime() async =>
      _preferences!.getInt(_activityElapsedTimeInSeconds) ?? 0;

  static backgroundTimestamp(int value) {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      init();
    }
    return _preferences!.setInt(_backgroundTimestampMiliseconds, value);
  }

  static Future<int> getBackgroundTimestamp() async =>
      _preferences!.getInt(_backgroundTimestampMiliseconds) ?? 0;

  static Future clearSharedPrefs() async {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      await init();
    }
    await _preferences!.clear();
  }

  static Future clearRecordedActivity() async {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      await init();
    }
    await _preferences!.remove(_pathLatitudeCoordinates);
    await _preferences!.remove(_pathLongitudeCoordinates);
    await _preferences!.remove(_activityStartTime);
    await _preferences!.remove(_activityElapsedTimeInSeconds);
    await _preferences!.remove(_backgroundTimestampMiliseconds);
  }

  static Future logout() async {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      await init();
    }
    await _preferences!.remove(_userUid);
  }
}
