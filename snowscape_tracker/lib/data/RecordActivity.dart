import 'package:mapbox_gl/mapbox_gl.dart';

class RecordedActivity {
  final String? id;
  DateTime startTime;
  late List<LatLng> points;
  late DateTime? endTime;
  double distance = 0.0;
  double averageSpeed = 0.0;
  int duration = 0;

  RecordedActivity({
    this.id,
    required this.startTime,
  }) {
    points = [];
  }
}
