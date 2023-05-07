import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class RecordedActivity {
  final String? id;
  DateTime startTime;
  late List<LatLng> points;
  late DateTime? endTime;
  double distance = 0.0;
  double averageSpeed = 0.0;
  int duration = 0;
  String tourName = "";
  String tourDescription = "";
  int difficulty = 0;

  RecordedActivity({
    this.id,
    required this.startTime,
  }) {
    points = [];
  }

  Map<String, dynamic> toMap() {
    List<GeoPoint> geoPoints = points
        .map((latlng) => GeoPoint(latlng.latitude, latlng.longitude))
        .toList();

    return {
      'startTime': startTime,
      'points': geoPoints,
      'endTime': endTime,
      'distance': distance,
      'averageSpeed': averageSpeed,
      'duration': duration,
      'tourName': tourName,
      'tourDescription': tourDescription,
      'difficulty': difficulty,
    };
  }
}
