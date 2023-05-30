import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:snowscape_tracker/data/planned_tour.dart';

class MapboxService {
  // Direction API
  String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  String? accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'];
  String navigationType = "walking";

  final dio = Dio();

  Future getRoute(LatLng start, LatLng finish) async {
    String url =
        '$baseUrl/$navigationType/${start.longitude},${start.latitude};${finish.longitude},${finish.latitude}?geometries=geojson&access_token=$accessToken';

    try {
      dio.options.contentType = Headers.jsonContentType;
      Response response = await dio.get(url);
      return response.data;
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Stream<int> getAllPointsElevation(List<Marker> points) async* {
    for (Marker marker in points) {
      String url =
          'https://api.mapbox.com/v4/mapbox.mapbox-terrain-v2/tilequery/${marker.point.longitude},${marker.point.latitude}.json?layers=contour&limit=50&access_token=$accessToken';

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

  Future<int> getElevationGain(List<Marker>? markers) async {
    if (markers == null || markers.isEmpty) {
      return 0;
    }
    var stream = getAllPointsElevation;
    int totalElevationGain = 0;
    int previousElevation = -1;

    await for (final value in stream(markers)) {
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

      previousElevation = value;
    }
    return totalElevationGain;
  }
}
