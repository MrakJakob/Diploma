import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/location_command.dart';
import 'package:snowscape_tracker/commands/logout_command.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:snowscape_tracker/models/location_model.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    var currentLocation = context.select<LocationModel, bg.Location?>(
      (locationModel) => locationModel.currentLocation,
    );

    debugPrint("currentLocation: $currentLocation");
    currentLocation != null
        ? MapCommand().updateCameraPosition(currentLocation)
        : null;

    void handleOnCurrentLocationPressed() {
      debugPrint('Current location pressed');
      LocationCommand().getCurrentLocation();
    }

    void onMapCreated(MapboxMapController controller) {
      debugPrint('Map created');
      MapCommand().initiateMap(controller);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map Page',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                LogoutCommand().execute();
              },
              child: const Icon(
                Icons.logout,
              ),
            ),
          )
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: MapboxMap(
        accessToken:
            'pk.eyJ1IjoibXJha2pha29iIiwiYSI6ImNsZm1vbjRoZzBkeDkzeW5yOWI0bHd0a2sifQ.roqcNX8j4FccFV5GBB8LJg',
        onMapCreated: onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(46.0569, 14.5058),
          zoom: 10.0,
          tilt: 0,
        ),
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          handleOnCurrentLocationPressed();
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.my_location_rounded),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.map),
                onPressed: () {},
                iconSize: 38,
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
                iconSize: 38,
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(
                  Icons.person,
                ),
                onPressed: () {},
                iconSize: 38,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    MapCommand()
        .resetController(); // added because the controller was not disposed correctly
    super.dispose();
  }
}
