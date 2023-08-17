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
    final dElevation = point3.elevation - point1.elevation;

    // Calculate the distance between point1 and point3
    final distance = calculateDistanceHaversine(point1.point, point3.point) *
        1000; // convert to meters *1000

    // Calculate the slope
    final slope = dElevation / distance;
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

  double calculateAzimuth(LatLng point1, LatLng point2) {
    var azimuth = atan2(
        sin(point2.longitude - point1.longitude),
        cos(point1.latitude) * sin(point2.latitude) -
            sin(point1.latitude) *
                cos(point2.latitude) *
                cos(point2.longitude - point1.longitude));
    // convert radians to degrees
    azimuth = azimuth * (180 / pi);

    // if azimuth is negative, we normalize it
    if (azimuth < 0.0) azimuth += 360;

    return azimuth;
  }

  double calculateAspect(ContextPoint point1, ContextPoint point2) {
    // calculate aspect using azimuth and slope
    final azimuth = calculateAzimuth(point1.point, point2.point);

    if (point2.elevation > point1.elevation) {
      // ascending, so the aspect is the opposite of the azimuth
      return (azimuth + 180) % (360);
    } else {
      // descending, so the aspect is the same as the azimuth
      return azimuth;
    }
  }

  List<ContextPoint> calculatePathAspect(List<ContextPoint> path) {
    final aspects = <double>[];

    for (var i = 0; i < path.length - 1; i++) {
      final point1 = path[i];
      final point2 = path[i + 1];

      double aspect = calculateAspect(point1, point2);

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

  double getApproximateDuration(List<ContextPoint> contextPoints) {
    // Calculate the approximate duration of the hike/ski walking for a given list of context points
    // This is done by using the Munter's calculation for ski touring https://muntercalculation.com/index.php#how_it_works:~:text=What%20the%20Munter%20Calculation%20is
    // 1 km of travel = 1 unit, 100 m of elevation change = 1 unit
    var climbingSpeedInUnits = 4;
    var descendingSpeedInUnits = 10;

    var totalClimbDistance = 0.0;
    var totalDescentDistance = 0.0;

    var totalElevationGain = 0.0;
    var totalElevationLoss = 0.0;

    for (var i = 0; i < contextPoints.length - 1; i++) {
      final point1 = contextPoints[i];
      final point2 = contextPoints[i + 1];

      final dElevation = point2.elevation - point1.elevation;
      final distance = point2.distanceFromStart - point1.distanceFromStart;

      if (dElevation > 0) {
        totalElevationGain += dElevation;
        totalClimbDistance += distance;
      } else {
        totalElevationLoss += dElevation;
        totalDescentDistance += distance;
      }
    }
    totalClimbDistance = totalClimbDistance / 1000; // convert to km
    totalDescentDistance = totalDescentDistance / 1000; // convert to km

    var elevationGainInUnits =
        totalElevationGain / 100; // convert to 100m units
    var elevationLossInUnits =
        totalElevationLoss.abs() / 100; // convert to 100m units

    var totalClimbTime =
        (totalClimbDistance + elevationGainInUnits) / climbingSpeedInUnits;
    var totalDescentTime =
        (totalDescentDistance + elevationLossInUnits) / descendingSpeedInUnits;

    final totalTime =
        (totalClimbTime + totalDescentTime) * 3600; // convert to seconds

    return totalTime;
  }
}
