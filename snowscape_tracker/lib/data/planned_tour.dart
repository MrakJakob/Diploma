import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

// we use this class to store the markers with already generated route information to this marker
class Marker {
  final LatLng point;
  double distanceAtMarker = 0.0;
  double durationAtMarker = 0.0;
  int elevationAtMarker = 0;
  bool isStartMarker = false;
  bool isFinishMarker = false;

  Marker(this.point, this.distanceAtMarker, this.durationAtMarker);
}

class PlannedTour {
  final String? id;
  String tourName = "";
  double distance = 0.0;
  int totalElevationGain = 0;
  double duration = 0;
  late List<Marker> markers;
  late List<LatLng> route;

  PlannedTour({
    this.id,
  }) {
    markers = [];
    route = [];
  }

  Map<String, dynamic> toMap() {
    // List<GeoPoint> markerGeoPoints = markers
    //     .map(
    //         (marker) => GeoPoint(marker.point.latitude, marker.point.longitude))
    //     .toList();

    List<Map<String, dynamic>> markersMap = markers // TODO: check if this works
        .map((marker) => {
              'point': GeoPoint(marker.point.latitude, marker.point.longitude),
              'distanceAtMarker': marker.distanceAtMarker,
              'durationAtMarker': marker.durationAtMarker,
            })
        .toList();

    List<GeoPoint> routeGeoPoints = route
        .map((latlng) => GeoPoint(latlng.latitude, latlng.longitude))
        .toList();

    return {
      'tourName': tourName,
      'distance': distance,
      'totalElevationGain': totalElevationGain,
      'markers': markersMap,
      'route': routeGeoPoints,
    };
  }

  factory PlannedTour.fromSnapshot(DocumentSnapshot snapshot) {
    // TODO: not yet tested
    PlannedTour getPlannedTourObjectFromData(data) {
      PlannedTour plannedTour = PlannedTour();

      if (data['points'] != null) {
        // TODO: check if this is correct
        List<Marker> markers = data['points'].map((marker) {
          return Marker(
            LatLng(marker.latitude, marker.longitude),
            marker.distanceAtMarker,
            marker.durationAtMarker,
          );
        }).toList();

        plannedTour.markers = markers;
      }

      if (data['route'] != null) {
        List<LatLng> route = data['route'].map<LatLng>((point) {
          return LatLng(point.latitude, point.longitude);
        }).toList();

        plannedTour.route = route;
      }

      if (data['tourName'] != null) {
        plannedTour.tourName = data['tourName'];
      }

      if (data['distance'] != null) {
        plannedTour.distance = data['distance'];
      }

      if (data['totalElevationGain'] != null) {
        plannedTour.totalElevationGain = data['totalElevationGain'];
      }

      return plannedTour;
    }

    return getPlannedTourObjectFromData(snapshot.data()!);
  }
}
