import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/data/mapbox_directions_response.dart';
import 'package:snowscape_tracker/services/mapbox_service.dart';

Future<MapboxDirectionsResponse> directionsApiResponseModified(
    LatLng start, LatLng finish) async {
  final response = await MapboxService().getRoute(start, finish);

  if (response == null) {
    debugPrint("Response is null");
    return MapboxDirectionsResponse();
  } else if (response['routes'].isEmpty) {
    debugPrint("Response is empty");
    return MapboxDirectionsResponse();
  }

  List<LatLng> route = response['routes'][0]['geometry']['coordinates']
      .map<LatLng>((point) => LatLng(point[1], point[0]))
      .toList();
  double duration = response['routes'][0]['duration'].toDouble();
  double distance = response['routes'][0]['distance'].toDouble();

  debugPrint("Modified response: $route");

  MapboxDirectionsResponse directionsResponse = MapboxDirectionsResponse();
  directionsResponse.route = route;
  directionsResponse.duration = duration;
  directionsResponse.distance = distance;
  return directionsResponse;
}
