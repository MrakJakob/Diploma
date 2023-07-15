import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:snowscape_tracker/commands/record_activity_command.dart';
import 'package:snowscape_tracker/helpers/geo_properties_calculator.dart';

class ContextPoint {
  LatLng point;
  double elevation;
  double aspect;
  double slope;
  double distanceFromStart;

  ContextPoint(this.point, this.elevation, this.aspect, this.slope,
      this.distanceFromStart);
}

class ArcGISService extends BaseCommand {
  final dio = Dio();

  List<List> formatPoints(List<LatLng> points) {
    List<List> formattedPoints = [];
    for (LatLng marker in points) {
      formattedPoints.add([
        marker.longitude,
        marker.latitude,
      ]);
    }
    return formattedPoints;
  }

  Future<Response?> submitJob(LatLng point) async {
    String url =
        "https://elevation.arcgis.com/arcgis/rest/services/Tools/Elevation/GPServer/SummarizeElevation/submitJob";

    try {
      // 1. submitting a job
      final response = await dio.post(
        url,
        queryParameters: {
          'token':
              'AAPKdd71a846aa114aa99a41c42d20b3b56axTyOGS9vd-DdXMptK5a0vWNL56_uajIO5SEZZ_oMtaQXFK5gsmw8NgjNVZ7lyfXP',
          'f': 'json',
          'InputFeatures': json.encode({
            'geometryType': 'esriGeometryPoint',
            'features': [
              {
                'geometry': {
                  'x': point.longitude,
                  'y': point.latitude,
                  'spatialReference': {
                    'wkid': 4326,
                  },
                },
                'attributes': {'Id': 1, 'Name': 'Point 1'},
              },
            ],
          }),
          'DEMResolution': 'FINEST',
          'IncludeSlopeAspect': true,
        },
      );
      return response;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  Future<bool> checkStatus(String jobId) async {
    // String url =
    //     "https://elevation.arcgis.com/arcgis/rest/services/Tools/Elevation/GPServer/SummarizeElevation/jobs/$jobId";

    String url =
        "https://elevation.arcgis.com/arcgis/rest/services/Tools/Elevation/GPServer/Profile/jobs/$jobId";
    const parameters = {
      "token":
          "AAPKdd71a846aa114aa99a41c42d20b3b56axTyOGS9vd-DdXMptK5a0vWNL56_uajIO5SEZZ_oMtaQXFK5gsmw8NgjNVZ7lyfXP",
      "f": "json"
    };
    bool response = false;

    try {
      await dio
          .get(
        url,
        queryParameters: parameters,
      )
          .then((value) async {
        debugPrint("Value: $value");
        while (value.data['jobStatus'] != "esriJobSucceeded") {
          if (value.data['jobStatus'] == "esriJobFailed") {
            return false;
          }
          sleep(Duration(seconds: 1));
          var newValue = await dio.get(url, queryParameters: parameters);
          value = newValue;
        }
        response = true;
      });
    } catch (e) {
      debugPrint("Error: $e");
    }
    return response;
  }

  Future<ContextPoint?> getResults(String jobId, LatLng point) async {
    var resultUrl =
        "https://elevation.arcgis.com/arcgis/rest/services/Tools/Elevation/GPServer/SummarizeElevation/jobs/$jobId/results/OutputSummary";
    ContextPoint? contextPoint;
    // 3. accessing results
    try {
      final response = await dio.get(
        resultUrl,
        queryParameters: {
          'token':
              'AAPKdd71a846aa114aa99a41c42d20b3b56axTyOGS9vd-DdXMptK5a0vWNL56_uajIO5SEZZ_oMtaQXFK5gsmw8NgjNVZ7lyfXP',
          'f': 'json',
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        var elevation = response.data['value']?['features'][0]?['attributes']
            ?['MeanElevation'];
        var slope =
            response.data['value']?['features'][0]?['attributes']?['MeanSlope'];
        var aspect = response.data['value']?['features'][0]?['attributes']
            ?['MeanAspect'];
        // LatLng point = LatLng(
        //     response.data['value']?['features'][0]?['geometry']?['y'],
        //     response.data['value']?['features'][0]?['geometry']?['x']);
        if (elevation == null || slope == null || aspect == null) {
          return null;
        }
        return ContextPoint(point, elevation.toDouble(), aspect.toDouble(),
            slope.toDouble(), 0);
      } else {
        throw Exception(response.statusCode);
      }
    } on Exception catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }

  Future<ContextPoint?> getPointsElevation(LatLng point) async {
    String url =
        "https://elevation.arcgis.com/arcgis/rest/services/Tools/Elevation/GPServer/SummarizeElevation/submitJob";
    // for (Marker marker in points) {

    // List<List> path = formatPoints(points);
    final response = await submitJob(point);
    if (response != null &&
        response.statusCode == 200 &&
        response.data != null) {
      var jobId = response.data['jobId'];
      var status = await checkStatus(jobId);
      if (status) {
        var result = await getResults(jobId, point);
        if (result != null) {
          return result;
        }
      }
    }
  }

  List<LatLng> getApproximateRoute(List<LatLng> route) {
    List<LatLng> approximateRoute = [];
    var previousPoint = route.first;
    route.forEach((point) {
      if (approximateRoute.isEmpty) {
        approximateRoute.add(point);
      } else {
        var lastPoint = approximateRoute.last;
        var distance = RecordActivityCommand().calculateDistanceBetweenPoints(
                lastPoint.latitude,
                lastPoint.longitude,
                point.latitude,
                point.longitude) *
            1000; // we convert the distance to meters
        // we check if the distance between two points is more than 50 meters and less than 100 meters
        if (distance > 250 && distance < 350) {
          // if it is we add the point to the approximate route
          approximateRoute.add(point);
        } else if (distance > 350) {
          // if the distance is more than 100 meters we add the previous point to the approximate route if that point is not already in the approximate route
          if (previousPoint != lastPoint) {
            approximateRoute.add(previousPoint);
          } else {
            // if the previous point is already in the approximate route we add the point to the approximate route even if the distance is more than 100 meters
            approximateRoute.add(point);
          }
        } else {
          // if the distance is less than 50 meters we skip the point
        }
      }
      previousPoint = point;
    });

    return approximateRoute;
  }

  Future<int> getElevationGain(List<LatLng>? route) async {
    if (route == null || route.isEmpty) {
      return 0;
    }

    List<LatLng> approximateRoute = getApproximateRoute(route);

    int totalElevationGain = 0;
    int previousElevation = -1;

    List<Future<ContextPoint?>> responses =
        route.map((point) => getPointsElevation(point)).toList();
    List<ContextPoint?> contextPoints = await Future.wait(responses);

    for (var point in route) {
      // the responses from api come in random order so we need to find the correct order to calculate elevation gain
      var orderedPoints = contextPoints.where(
        (contexPoint) => contexPoint?.point == point,
      );
      if (orderedPoints.isEmpty) {
        continue;
      }
      var orderedPoint = orderedPoints.first;
      if (orderedPoint != null) {
        if (previousElevation == -1) {
          previousElevation = orderedPoint.elevation.round();
          continue;
        }

        if (orderedPoint.elevation.round() > previousElevation) {
          totalElevationGain +=
              orderedPoint.elevation.round() - previousElevation;
        }
        previousElevation = orderedPoint.elevation.round();
      }
    }
    // await for (final value in stream(route)) {
    //   if (value == null) {
    //     continue;
    //   }

    //   if (previousElevation == -1) {
    //     previousElevation = value.elevation.round();
    //     continue;
    //   }

    //   if (value.elevation.round() > previousElevation) {
    //     totalElevationGain += value.elevation.round() - previousElevation;
    //   }
    //   previousElevation = value.elevation.round();
    // }
    return totalElevationGain;
  }

  Future<Response?> submitJobNew(List<LatLng> path) async {
    String url =
        "https://elevation.arcgis.com/arcgis/rest/services/Tools/Elevation/GPServer/Profile/submitJob";

    try {
      final response = await dio.post(
        url,
        queryParameters: {
          'token':
              'AAPKdd71a846aa114aa99a41c42d20b3b56axTyOGS9vd-DdXMptK5a0vWNL56_uajIO5SEZZ_oMtaQXFK5gsmw8NgjNVZ7lyfXP',
          'f': 'json',
          'InputLineFeatures': json.encode(
            {
              "geometryType": "esriGeometryPolyline",
              "features": [
                {
                  "geometry": {
                    "paths": [
                      path
                          .map(
                            (e) => [e.longitude, e.latitude],
                          )
                          .toList()
                    ],
                    "spatialReference": {"wkid": 4326}
                  }
                }
              ]
            },
          ),
          'DEMResolution': 'FINEST',
        },
      );
      if (response != null) {
        debugPrint("Response: ${response.data}");
      }
      return response;
    } on Exception catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }

  Future<List<ContextPoint>?> getResultsNew(
      String jobId, List<LatLng> points) async {
    List<ContextPoint>? contextPoints = [];
    String resultsUrl =
        "https://elevation.arcgis.com/arcgis/rest/services/Tools/Elevation/GPServer/Profile/jobs/$jobId/results/OutputProfile";

    try {
      final response = await dio.get(
        resultsUrl,
        queryParameters: {
          'token':
              'AAPKdd71a846aa114aa99a41c42d20b3b56axTyOGS9vd-DdXMptK5a0vWNL56_uajIO5SEZZ_oMtaQXFK5gsmw8NgjNVZ7lyfXP',
          'f': 'json',
          'returnZ': true,
          'returnM': true,
        },
      );
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        var path =
            response.data['value']['features'][0]['geometry']['paths'][0];
        debugPrint("Response: ${response.data}");
        for (var i = 0; i < path.length; i++) {
          var point = path[i];
          var contextPoint = ContextPoint(LatLng(point[1], point[0]),
              point[2].toDouble(), 0, 0, point[3].toDouble());
          contextPoints.add(contextPoint);
        }
      }
    } on Exception catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
    if (contextPoints == null || contextPoints.isEmpty) {
      return contextPoints;
    }
    GeoPropertiesCalculator().calculatePathSlope(contextPoints);
    GeoPropertiesCalculator().calculatePathAspect(contextPoints);

    return contextPoints;
  }

  Future<void> getPathElevation(List<LatLng> path) async {
    if (path.isEmpty) {
      return;
    }

    List<LatLng> newRoute = path;

    while (newRoute.isNotEmpty) {
      List<LatLng> newRoute = path.length > 410 ? path.sublist(0, 410) : path;
      final response = await submitJobNew(newRoute);
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        var jobId = response.data['jobId'];
        var status = await checkStatus(jobId);
        if (status) {
          List<ContextPoint>? contextPoints =
              await getResultsNew(jobId, newRoute);

          if (contextPoints == null || contextPoints.isEmpty) {
            return;
          }

          plannedTourModel.setContextPoints = [
            ...plannedTourModel.contextPoints,
            ...contextPoints
          ];

          double totalElevationGain =
              GeoPropertiesCalculator().calculateElevationGain(contextPoints);

          // we have to add the elevation gain to the total elevation gain of the tour in case we have more than 1000 points
          plannedTourModel.setTotalElevationGain =
              plannedTourModel.totalElevationGain + totalElevationGain;
        }
      }
      path.removeRange(0, newRoute.length);
    }
    // we recalculate the duration of the tour using the Munter's method
    // and we also include routes that were not generated using the
    // directions API, but were drawn as straight lines between points by the user
    double approximateSkiTourDuration = GeoPropertiesCalculator()
        .getApproximateDuration(plannedTourModel.contextPoints);

    plannedTourModel.setDuration = approximateSkiTourDuration;

    // we set the distance of the tour to the distance of the context point which
    // includes the points that were not generated using the directions API,
    // but were drawn as straight lines between points by the user
    plannedTourModel.setDistance =
        plannedTourModel.contextPoints.last.distanceFromStart;
  }

  Future<void> getRecordedPathElevationAndRecalculateDistance(
      List<LatLng> points) async {
    if (points.isEmpty) {
      return;
    }

    List<LatLng> newPoints = points;

    while (newPoints.isNotEmpty) {
      // if we have more than 1000 points, we need to split them into multiple requests, because the API can only handle 1000 points at a time
      newPoints = points.length > 1000 ? points.sublist(0, 1000) : points;

      final response = await submitJobNew(newPoints);
      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {
        var jobId = response.data['jobId'];
        var status = await checkStatus(jobId);
        if (status) {
          List<ContextPoint>? contextPoints =
              await getResultsNew(jobId, newPoints);

          if (contextPoints == null || contextPoints.isEmpty) {
            return;
          }

          // We need to recalculate distance because the distance and avg. speed calculated during recording is not accurate
          recordActivityModel.setDistance =
              contextPoints.last.distanceFromStart;
          recordActivityModel.setAverageSpeed = recordActivityModel.distance /
              (recordActivityModel.getDuration / 3600);

          double totalElevationGain =
              GeoPropertiesCalculator().calculateElevationGain(contextPoints);

          // we need to add the elevation gain to the total elevation gain in case we have more than 1000 points
          recordActivityModel.elevationGain =
              recordActivityModel.getElevationGain + totalElevationGain;
        }
      }
      // remove the points that were already processed
      points.removeRange(0, newPoints.length);
    }
  }
}
