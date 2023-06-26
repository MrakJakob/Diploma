import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/data/rules/matched_rule.dart';

// we use this class to store the markers with already generated route information to this marker
class Marker {
  String id;
  String? plannedTourId;
  LatLng point;
  double distanceAtMarker = 0.0;
  double durationAtMarker = 0.0;
  int elevationAtMarker = 0;
  bool isStartMarker = false;
  bool isFinishMarker = false;

  Marker(this.id, this.point, this.distanceAtMarker, this.durationAtMarker);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plannedTourId': plannedTourId ?? '',
      'latitude': point.latitude,
      'longitude': point.longitude,
      'distanceAtMarker': distanceAtMarker,
      'durationAtMarker': durationAtMarker,
      'elevationAtMarker': elevationAtMarker,
      'isStartMarker': isStartMarker,
      'isFinishMarker': isFinishMarker,
    };
  }

  Marker.fromMap(Map map)
      : id = map['id'],
        plannedTourId = map['plannedTourId'],
        point = LatLng(map['latitude'], map['longitude']),
        distanceAtMarker = map['distanceAtMarker'],
        durationAtMarker = map['durationAtMarker'],
        elevationAtMarker = map['elevationAtMarker'],
        isStartMarker = map['isStartMarker'] == 1,
        isFinishMarker = map['isFinishMarker'] == 1;

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS markers (id TEXT PRIMARY KEY,
    plannedTourId TEXT,
    latitude REAL, longitude REAL,
    distanceAtMarker REAL, durationAtMarker REAL,
    elevationAtMarker INTEGER, isStartMarker INTEGER,
    isFinishMarker INTEGER,
    FOREIGN KEY(plannedTourId) REFERENCES planned_tours(id) ON DELETE CASCADE,FOREIGN KEY(plannedTourId) REFERENCES planned_tours(id) ON DELETE CASCADE
    )''';
  }
}

class PlannedTour {
  String? id;
  String tourName = "";
  double distance = 0.0;
  double totalElevationGain = 0;
  double duration = 0;
  late List<Marker> markers;
  late List<LatLng> route;
  late List<MatchedRule>? matchedRules;

  PlannedTour({
    this.id,
  }) {
    markers = [];
    route = [];
    matchedRules = [];
  }
}
