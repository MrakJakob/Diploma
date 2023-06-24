import 'package:mapbox_gl/mapbox_gl.dart';

class RoutePointDb {
  String id;
  String plannedTourId;
  LatLng point;

  RoutePointDb(this.id, this.plannedTourId, this.point);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plannedTourId': plannedTourId,
      'latitude': point.latitude,
      'longitude': point.longitude,
    };
  }

  RoutePointDb.fromMap(Map map)
      : id = map['id'],
        plannedTourId = map['plannedTourId'],
        point = LatLng(map['latitude'], map['longitude']);

  static createTable() {
    return '''CREATE TABLE IF NOT EXISTS route_points (id TEXT PRIMARY KEY, plannedTourId TEXT, latitude REAL, longitude REAL )''';
  }
}
