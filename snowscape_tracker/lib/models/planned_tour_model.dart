import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/data/planned_tour.dart';
import 'package:snowscape_tracker/data/rules/matched_rule.dart';
import '../services/mapbox_service.dart';

class PlannedTourModel extends ChangeNotifier {
  bool _isTourPlanning = false;
  PlannedTour? _plannedTour;
  bool _drawStraightLine = false;
  bool _loadingPathData = false;
  List<ContextPoint> _contextPoints = [];
  // List<MatchedRule> _matchedRules = [];

  set setLoadingPathData(bool status) {
    _loadingPathData = status;
    notifyListeners();
  }

  bool get loadingPathData => _loadingPathData;

  // we set this to true when the user sets the first marker on the map
  set isTourPlanning(bool status) {
    _isTourPlanning = status;
    notifyListeners();
  }

  set setId(String? id) {
    _plannedTour?.id = id;
    notifyListeners();
  }

  get id => _plannedTour?.id;

  bool get isTourPlanning => _isTourPlanning;

  final TextEditingController _plannedTourNameController =
      TextEditingController();

  TextEditingController get plannedTourNameController =>
      _plannedTourNameController;

  void createPlannedTour() {
    _plannedTour = PlannedTour();
  }

  set setPlannedTour(PlannedTour? plannedTour) {
    _plannedTour = plannedTour;
    notifyListeners();
  }

  get plannedTour => _plannedTour;

  get contextPoints => _contextPoints;

  set setContextPoints(List<ContextPoint> contextPoints) {
    _contextPoints = contextPoints;
    notifyListeners();
  }

  get matchedRules => _plannedTour?.matchedRules;

  set setMatchedRules(List<MatchedRule> matchedRules) {
    _plannedTour?.matchedRules = matchedRules;
    notifyListeners();
  }

  set marker(Marker marker) {
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   // addPostFrameCallback is used to avoid the error "setState() or markNeedsBuild() called during build"
    //   // reference: https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
    //   _plannedTour?.markers.add(marker);
    //   notifyListeners();
    // });
    _plannedTour?.markers.add(marker);
    notifyListeners();
  }

  void removeLastMarker() {
    // remove last positioned marker in the list
    _plannedTour?.markers.removeLast();
    notifyListeners();
  }

  set setMarkers(List<Marker> markers) {
    _plannedTour?.markers = markers;
    notifyListeners();
  }

  get markers => _plannedTour?.markers;

  get lastMarker =>
      plannedTour?.markers.length > 0 ? _plannedTour?.markers.last : null;

  set setRoute(List<LatLng> route) {
    _plannedTour?.route = route;
    notifyListeners();
  }

  get route => _plannedTour?.route;

  void addRoute(List<LatLng> route) {
    _plannedTour?.route.addAll(route);
    notifyListeners();
  }

  Future<void> removeLastRoute() async {
    // remove last added segment in the route
    List<LatLng> route = _plannedTour?.route ?? [];
    Marker? lastMarker = _plannedTour?.markers.last;
    if (lastMarker != null && _plannedTour?.route != null) {
      var nearestPoint = route.isEmpty
          ? null
          : route.reduce(
              (a, b) => (a.latitude - lastMarker.point.latitude).abs() +
                          (a.longitude - lastMarker.point.longitude).abs() <
                      (b.latitude - lastMarker.point.latitude).abs() +
                          (b.longitude - lastMarker.point.longitude).abs()
                  ? a
                  : b,
            );
      var index = nearestPoint != null ? route.indexOf(nearestPoint) : -1;
      if (index != -1) {
        // we find the closest marker in the route and remove all the markers after that
        for (int i = index! + 1; i < _plannedTour!.route.length; i++) {
          if ((_plannedTour!.route[i].latitude - lastMarker.point.latitude)
                      .abs() <
                  (_plannedTour!.route[index!].latitude -
                          lastMarker.point.latitude)
                      .abs() &&
              (_plannedTour!.route[i].longitude - lastMarker.point.longitude)
                      .abs() <
                  (_plannedTour!.route[index!].longitude -
                          lastMarker.point.longitude)
                      .abs()) {
            index = i;
          } else {
            break;
          }
        }
        // create a sublist from the beginning to the index of the last marker
        List<LatLng>? sublist = _plannedTour?.route.sublist(0, index);
        _plannedTour?.route = sublist ?? [];
        return Future.value();
      }
    }
    notifyListeners();
  }

  set setTourName(String name) {
    _plannedTour?.tourName = name;
    notifyListeners();
  }

  get tourName => _plannedTour?.tourName;

  set setDistance(double distance) {
    _plannedTour?.distance = distance;
    notifyListeners();
  }

  get distance => _plannedTour?.distance;

  set setTotalElevationGain(int elevationGain) {
    _plannedTour?.totalElevationGain = elevationGain;
    notifyListeners();
  }

  get totalElevationGain => _plannedTour?.totalElevationGain;

  get duration => _plannedTour?.duration;

  set setDuration(double duration) {
    _plannedTour?.duration = duration;
    notifyListeners();
  }

  get drawStraightLine => _drawStraightLine;

  set setDrawStraightLine(bool status) {
    _drawStraightLine = status;
    notifyListeners();
  }
}
