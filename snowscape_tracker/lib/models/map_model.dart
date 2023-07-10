import 'package:mapbox_gl/mapbox_gl.dart';
import "package:flutter/material.dart";

class MapModel extends ChangeNotifier {
  MapboxMapController? mapController;
  bool _recordingContainerVisible = false;
  bool _tourPlanningContainerVisible = false;
  String _selectedFunctionality = "none";
  int _explorePageSelectedItemIndex = 0;

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

  set setSelectedFunctionality(String func) {
    _selectedFunctionality = func;
    notifyListeners();
  }

  get selectedFunctionality => _selectedFunctionality;

  set setExplorePageSelectedItemIndex(int index) {
    _explorePageSelectedItemIndex = index;
    notifyListeners();
  }

  get explorePageSelectedItemIndex => _explorePageSelectedItemIndex;
}
