import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:snowscape_tracker/commands/map_command.dart';

class SmallMapWithRecordedActivity extends StatelessWidget {
  final List<LatLng> points;

  const SmallMapWithRecordedActivity(this.points, {super.key});

  void onMapCreated(MapboxMapController controller) {
    MapCommand().initiateMap(controller);
    MapCommand().updatePolyline(points, "recorded", controller);
  }

  @override
  Widget build(BuildContext context) {
    var map = MapboxMap(
      accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "MAPBOX_ACCESS_TOKEN",
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(points.first.latitude, points.first.longitude),
        zoom: 12,
      ),
    );

    return GestureDetector(
        onDoubleTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Scaffold(
                  appBar: AppBar(
                    flexibleSpace: SafeArea(
                      child: Center(
                        child: Text(
                          "Map",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  body: map)));
        },
        child: SizedBox(width: double.infinity, height: 200, child: map));
  }
}
