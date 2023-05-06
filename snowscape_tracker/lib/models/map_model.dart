import 'package:mapbox_gl/mapbox_gl.dart';
import "package:flutter/material.dart";

class MapModel extends ChangeNotifier {
  MapboxMapController? mapController;
  bool _recordingContainerVisible = false;

  void initiateMap(MapboxMapController controller) {
    mapController = controller;
    notifyListeners();
  }

  set recordingContainerVisible(bool status) {
    _recordingContainerVisible = status;
    notifyListeners();
  }

  bool get recordingContainerVisible => _recordingContainerVisible;
}
