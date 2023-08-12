import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/explore_command.dart';
import 'package:snowscape_tracker/commands/location_command.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:snowscape_tracker/data/recorded_activity.dart';
import 'package:snowscape_tracker/helpers/formating.dart';
import 'package:snowscape_tracker/helpers/geo_properties_calculator.dart';
import 'package:snowscape_tracker/models/location_model.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:snowscape_tracker/utils/snack_bar.dart';
import 'package:snowscape_tracker/views/recorded_activity_details.dart';

class ExplorePage extends StatefulWidget {
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<RecordedActivity> recordedActivitiesData = [];
  bool firstLoad = true;
  bool internetConnection = true;
  bool disabledButton = false;

  @override
  Widget build(BuildContext context) {
    bg.Location? currentLocation = context.select<LocationModel, bg.Location?>(
      (locationModel) => locationModel.currentLocation,
    );

    void handleLocationUpdate(bg.Location currentLocationArg) {
      if (firstLoad) {
        setState(() {
          firstLoad = false;
        });
      }
      MapCommand().updateCameraPosition(currentLocationArg);
    }

    Future<void> handleOnCurrentLocationPressed() async {
      await LocationCommand().getCurrentLocation();
      currentLocation != null ? handleLocationUpdate(currentLocation) : null;
    }

    Future<void> checkConnectivity() async {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi) {
        SnackBarWidget.show("No internet connection", null);
        setState(() {
          internetConnection = false;
        });
      } else {
        setState(() {
          internetConnection = true;
        });
      }
      return;
    }

    void onMapCreated(MapboxMapController controller) async {
      // debugPrint('Map created');
      MapCommand().initiateMap(controller);

      await checkConnectivity();

      Stream<List<RecordedActivity>>? recordedActivityStream =
          ExploreCommand().readPublicRecordedSessions();

      recordedActivityStream!.listen((recordedActivities) async {
        if (currentLocation != null && recordedActivities != null) {
          recordedActivities.sort((a, b) => GeoPropertiesCalculator()
              .calculateDistanceHaversine(
                  a.points.first,
                  LatLng(currentLocation.coords.latitude,
                      currentLocation.coords.longitude))
              .compareTo(
                GeoPropertiesCalculator().calculateDistanceHaversine(
                  b.points.first,
                  LatLng(currentLocation.coords.latitude,
                      currentLocation.coords.longitude),
                ),
              ));
        }

        if (recordedActivities != null) {
          for (var recordedActivity in recordedActivities) {
            if (recordedActivity.points.isNotEmpty && currentLocation != null) {
              await MapCommand().showRecordedActivityMarker(recordedActivity);
            }
          }
          setState(() {
            recordedActivitiesData = recordedActivities;
          });
          if (recordedActivitiesData.isNotEmpty) {
            MapCommand().showRecordedActivity(
                recordedActivitiesData.first, false, context);
          }
        }
      });
    }

    currentLocation != null && firstLoad
        ? handleLocationUpdate(currentLocation)
        : null; // handle location update only if the current location is not null

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: Center(
              child: Text(
                'Explore page',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Stack(
          children: [
            MapboxMap(
              accessToken:
                  dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "MAPBOX_ACCESS_TOKEN",
              onMapCreated: onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(46.0569, 14.5058),
                zoom: 10.0,
                tilt: 0,
              ),
              myLocationEnabled: true,
              styleString:
                  "mapbox://styles/mrakjakob/clfmp41bl001x01mtoth3xqxw",
            ),
            CarouselSlider(
              items: recordedActivitiesData
                  .map((recordedActivity) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RecordedActivityDetails(
                                  recordedActivity, "shared_from_explore_page"),
                            ),
                          );
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Image(
                                    image: AssetImage('assets/mountain.png'),
                                    width: 40,
                                    height: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recordedActivity.tourName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      RatingBarIndicator(
                                        rating: recordedActivity.difficulty
                                            .toDouble(),
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                      ),
                                      // const SizedBox(height: 5),
                                      // Text(
                                      //   recordedActivity.userName.isNotEmpty
                                      //       ? recordedActivity.userName
                                      //       : 'Anonymous',
                                      //   style: const TextStyle(
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.normal,
                                      //     color: Colors.white,
                                      //   ),
                                      //   overflow: TextOverflow.ellipsis,
                                      // ),
                                      const SizedBox(height: 5),
                                      Text(
                                          '${recordedActivity.distance.toStringAsFixed(2)} km, ${printDuration(Duration(seconds: recordedActivity.duration), true)}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 100,
                viewportFraction: 0.6,
                initialPage: 0,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  MapCommand().setExplorePageSelectedItemIndex(index);
                  MapCommand().showRecordedActivity(
                      recordedActivitiesData[index], true, context);
                },
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: disabledButton
              ? null
              : () {
                  setState(() {
                    disabledButton = true;
                  });
                  handleOnCurrentLocationPressed().then((value) {
                    setState(() {
                      disabledButton = false;
                    });
                  });
                },
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Icon(
              TablerIcons.current_location,
              color: disabledButton
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).primaryColor,
              size: 28,
            ),
          ),
        ));
  }

  @override
  void dispose() {
    MapCommand()
        .resetController(); // added because the controller was not disposed correctly
    super.dispose();
  }
}
