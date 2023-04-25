import 'package:mapbox_gl/mapbox_gl.dart';
import "package:flutter/material.dart";

class MapModel extends ChangeNotifier {
  MapboxMapController? mapController;

  void initiateMap(MapboxMapController controller) {
    mapController = controller;
    notifyListeners();
  }
}
