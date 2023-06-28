import 'dart:math';

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/services/arcGIS_service.dart';

class GeoPropertiesCalculator {
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

  double calculateSlopeWithElevation(
      ContextPoint point1, ContextPoint point2, ContextPoint point3) {
    // Calculate the change in elevation between point1 and point3
    final dElevation1 = point2.elevation - point1.elevation;
    final dElevation2 = point3.elevation - point2.elevation;

    // Calculate the distance between point1 and point3
    final distance = calculateDistanceHaversine(point1.point, point2.point) *
        1000; // convert to meters *1000

    // Interpolate the elevation at the midpoint between p1 and p3
    final midpointElevation = point1.elevation +
        (distance / 2) * (dElevation1 + dElevation2) / (2 * distance);

    // Calculate the slope
    final slope = (midpointElevation - point1.elevation) / (distance / 2);
    final slopeDegrees = atan(slope) * (180 / pi);

    return slopeDegrees;
  }

  List<ContextPoint> calculatePathSlope(List<ContextPoint> path) {
    final slopes = <double>[];

    for (var i = 0; i < path.length - 2; i++) {
      final point1 = path[i];
      final point2 = path[i + 1];
      final point3 = path[i + 2];

      final slope = calculateSlopeWithElevation(point1, point2, point3);
      // slopes.add(slope);
      path[i + 1].slope = slope;
    }

    return path;
  }

  double calculateAspectWithElevation(ContextPoint point1, ContextPoint point2,
      ContextPoint point3, ContextPoint point4) {
    final dx1 = point2.point.longitude - point1.point.longitude;
    final dy1 = point2.point.latitude - point1.point.latitude;
    final dx2 = point3.point.longitude - point2.point.longitude;
    final dy2 = point3.point.latitude - point2.point.latitude;
    final dx3 = point4.point.longitude - point3.point.longitude;
    final dy3 = point4.point.latitude - point3.point.latitude;

    final dElevation1 = point2.elevation - point1.elevation;
    final dElevation2 = point3.elevation - point2.elevation;
    final dElevation3 = point4.elevation - point3.elevation;

    // Calculate the aspect using elevation differences and weighted average of arctangents
    final aspect = atan2(
            (dElevation1 * dx3 + dElevation2 * dx1 + dElevation3 * dx2),
            (dElevation1 * dy3 + dElevation2 * dy1 + dElevation3 * dy2)) *
        (180 / pi);

    // adjust the aspect to be between 0 and 360
    final adjustedAspect = (aspect + 360) % 360;

    return adjustedAspect;
  }

  List<ContextPoint> calculatePathAspect(List<ContextPoint> path) {
    final aspects = <double>[];

    for (var i = 0; i < path.length - 3; i++) {
      final point1 = path[i];
      final point2 = path[i + 1];
      final point3 = path[i + 2];
      final point4 = path[i + 3];

      final aspect =
          calculateAspectWithElevation(point1, point2, point3, point4);

      path[i + 1].aspect = aspect;
    }

    return path;
  }

  double calculateElevationGain(List<ContextPoint> path) {
    double elevationGain = 0.0;

    for (var i = 0; i < path.length - 1; i++) {
      final point1 = path[i];
      final point2 = path[i + 1];

      final dElevation = point2.elevation - point1.elevation;

      if (dElevation > 0) {
        elevationGain += dElevation;
      }
    }

    return elevationGain;
  }
}
