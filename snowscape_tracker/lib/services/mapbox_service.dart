import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:snowscape_tracker/helpers/geo_properties_calculator.dart';
import 'package:snowscape_tracker/services/arcGIS_service.dart';

class MapboxService extends BaseCommand {
  // Direction API
  String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  String? accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'];
  String navigationType = "walking";
  final dio = Dio();

  Future getRoute(LatLng start, LatLng finish) async {
    String url =
        '$baseUrl/$navigationType/${start.longitude},${start.latitude};${finish.longitude},${finish.latitude}?geometries=geojson&access_token=$accessToken&walking_speed=1';

    try {
      dio.options.contentType = Headers.jsonContentType;
      Response response = await dio.get(url);
      return response.data;
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Stream<int> getAllPointsElevation(List<LatLng> points) async* {
    for (LatLng point in points) {
      String url =
          'https://api.mapbox.com/v4/mapbox.mapbox-terrain-v2/tilequery/${point.longitude},${point.latitude}.json?layers=contour&limit=50&access_token=$accessToken';

      try {
        dio.options.contentType = Headers.jsonContentType;
        Response response = await dio.get(url);
        if (response.data != null && response.data.isNotEmpty) {
          var allFeatures = response.data['features'];
          // we get multiple elevation data for each point, so we need to find the highest one
          var elevations = allFeatures.map((e) {
            var elevation = e['properties']['ele'];
            // debugPrint("Elevation: $elevation");
            return elevation;
          }).toList();
          // debugPrint("Elevations: $elevations");

          int highestElevation =
              [...elevations].reduce((a, b) => a > b ? a : b);

          debugPrint("Highest elevation: $highestElevation");
          yield highestElevation;
        }
      } catch (e) {
        debugPrint("Error: $e");
        yield 0;
      }
    }
  }

  List<ContextPoint> removeUniformativePoints(
      List<ContextPoint> contextPoints) {
    // TODO: check if useful
    List<ContextPoint> newContextPoints = [];
    for (int i = 0; i < contextPoints.length; i++) {
      if (newContextPoints.isEmpty) {
        if (contextPoints[i].slope != 0 && contextPoints[i].aspect != 0) {
          newContextPoints.add(contextPoints[i]);
        }

        continue;
      }
      if (contextPoints[i].slope != 0 && contextPoints[i].aspect != 0) {
        newContextPoints.add(contextPoints[i]);
      }
    }
    return newContextPoints;
  }

  Future<int> getElevationGain(List<LatLng>? route) async {
    if (route == null || route.isEmpty) {
      return 0;
    }
    int totalElevationGain = 0;
    int previousElevation = -1;
    int index = 0;

    var stream = getAllPointsElevation;

    List<ContextPoint> contextPoints = [];

    await for (final value in stream(route)) {
      if (value == null) {
        continue;
      }

      if (previousElevation == -1) {
        previousElevation = value;
        continue;
      }
      if (value > previousElevation) {
        totalElevationGain += value - previousElevation;
      }
      contextPoints.add(ContextPoint(route[index], value.toDouble(), 0, 0, 0));
      index++;
      previousElevation = value;
    }

    // calculate aspect and slope
    contextPoints = calculatePathSlope(contextPoints);
    contextPoints = calculatePathAspect(contextPoints);
    // remove uniformative points
    // contextPoints = removeUniformativePoints(contextPoints);

    // save the context points to the model
    plannedTourModel.setContextPoints = contextPoints;
    debugPrint(
        "${contextPoints.map((e) => "Slope: ${e.slope} aspect: ${e.aspect}")}");
    return totalElevationGain;
  }

  double calculateSlopeWithElevation(
      ContextPoint point1, ContextPoint point2, ContextPoint point3) {
    // Calculate the change in elevation between point1 and point3
    final dElevation1 = point2.elevation - point1.elevation;
    final dElevation2 = point3.elevation - point2.elevation;

    // Calculate the distance between point1 and point3
    final distance = GeoPropertiesCalculator()
            .calculateDistanceHaversine(point1.point, point2.point) *
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
}
