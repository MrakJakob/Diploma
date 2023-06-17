import 'dart:math';

import 'package:mapbox_gl/mapbox_gl.dart';

// Returns the distance between two points in km
double calculateDistanceHaversine(LatLng point1, LatLng point2) {
  final lat1 = point1.latitude * pi / 180;
  final lon1 = point1.longitude * pi / 180;
  final lat2 = point2.latitude * pi / 180;
  final lon2 = point2.longitude * pi / 180;

  final deltaLat = lat2 - lat1;
  final deltaLon = lon2 - lon1;

  final a = pow(sin(deltaLat / 2), 2) +
      cos(lat1) * cos(lat2) * pow(sin(deltaLon / 2), 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  const double earthRadius = 6371.0; // km

  final distance = earthRadius * c;
  return distance;
}
