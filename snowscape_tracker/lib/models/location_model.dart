import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class LocationModel extends ChangeNotifier {
  // holds the location of the user
  bg.Location? _currentLocation;

  // getter for the current location
  bg.Location? get currentLocation => _currentLocation;

  // setter for the current location
  set currentLocation(bg.Location? location) {
    _currentLocation = location;
    notifyListeners();
  }
}
