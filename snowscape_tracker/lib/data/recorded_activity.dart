import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class RecordedActivity {
  String? id;
  DateTime startTime;
  late List<LatLng> points;
  late DateTime? endTime;
  double distance = 0.0;
  double averageSpeed = 0.0;
  int duration = 0;
  String tourName = "";
  String tourDescription = "";
  int difficulty = 3;
  bool isPublic = false;
  String userId = "";
  String userName = "Anonymous user";
  double elevationGain = 0.0;

  RecordedActivity({
    this.id,
    required this.startTime,
  }) {
    points = [];
  }

  // transform a RecordedActivity object to a Map (Firestore document)
  Map<String, dynamic> toMap() {
    List<GeoPoint> geoPoints = points
        .map((latlng) => GeoPoint(latlng.latitude, latlng.longitude))
        .toList();

    return {
      'id': id,
      'startTime': startTime,
      'points': geoPoints,
      'endTime': endTime,
      'distance': distance,
      'averageSpeed': averageSpeed,
      'duration': duration,
      'tourName': tourName,
      'tourDescription': tourDescription,
      'difficulty': difficulty,
      'isPublic': isPublic,
      'userId': userId,
      'userName': userName,
      'elevationGain': elevationGain,
    };
  }

  // get a RecordedActivity object from a Firestore DocumentSnapshot
  factory RecordedActivity.fromSnapshot(DocumentSnapshot snapshot) {
    RecordedActivity getRecordedActivityObjectFromData(data) {
      RecordedActivity recordedActivity = RecordedActivity(
        startTime: data['startTime'].toDate(),
      );

      if (data['id'] != null) {
        recordedActivity.id = data['id'];
      }

      if (data['points'] != null) {
        List<LatLng> points = data['points'].map<LatLng>((point) {
          return LatLng(point.latitude, point.longitude);
        }).toList();

        recordedActivity.points = points;
      }

      if (data['endTime'] != null) {
        recordedActivity.endTime = data['endTime'].toDate();
      }

      if (data['distance'] != null) {
        recordedActivity.distance = data['distance'];
      }

      if (data['averageSpeed'] != null) {
        recordedActivity.averageSpeed = data['averageSpeed'];
      }

      if (data['duration'] != null) {
        recordedActivity.duration = data['duration'];
      }

      if (data['tourName'] != null) {
        recordedActivity.tourName = data['tourName'];
      }

      if (data['tourDescription'] != null) {
        recordedActivity.tourDescription = data['tourDescription'];
      }

      if (data['difficulty'] != null) {
        recordedActivity.difficulty = data['difficulty'];
      }

      if (data['isPublic'] != null) {
        recordedActivity.isPublic = data['isPublic'];
      }

      if (data['userId'] != null) {
        recordedActivity.userId = data['userId'];
      }

      if (data['userName'] != null) {
        recordedActivity.userName = data['userName'];
      }

      if (data['elevationGain'] != null) {
        recordedActivity.elevationGain = data['elevationGain'];
      }

      return recordedActivity;
    }

    var data = snapshot.data();

    return getRecordedActivityObjectFromData(data);
  }
}
