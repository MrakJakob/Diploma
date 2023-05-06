import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;

  static const String _isRecording = 'isRecording';
  static const String _pathLongitudeCoordinates = 'pathLongitudeCoordinates';
  static const String _pathLatitudeCoordinates = 'pathLatitudeCoordinates';
  static const String _activityStartTime = 'activityStartTime';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setRecording(bool isRecording) async {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      await init();
    }
    await _preferences!.setBool(_isRecording, isRecording);
  }

  static bool getRecording() => _preferences!.getBool(_isRecording) ?? false;

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

  static Future clearSharedPrefs() async {
    if (_preferences == null) {
      // if the preferences haven't been initialized yet, we need to initialize them
      await init();
    }
    await _preferences!.clear();
  }
}
