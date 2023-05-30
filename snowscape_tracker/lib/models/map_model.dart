import 'package:mapbox_gl/mapbox_gl.dart';
import "package:flutter/material.dart";

class MapModel extends ChangeNotifier {
  MapboxMapController? mapController;
  bool _recordingContainerVisible = false;
  bool _tourPlanningContainerVisible = false;

  void initiateMap(MapboxMapController controller) {
    mapController = controller;
    notifyListeners();
  }

  set recordingContainerVisible(bool status) {
    _recordingContainerVisible = status;
    notifyListeners();
  }

  bool get recordingContainerVisible => _recordingContainerVisible;

  set tourPlanningContainerVisible(bool status) {
    _tourPlanningContainerVisible = status;
    notifyListeners();
  }

  bool get tourPlanningContainerVisible => _tourPlanningContainerVisible;
}
