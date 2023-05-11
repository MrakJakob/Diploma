import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/location_command.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:snowscape_tracker/commands/record_activity_command.dart';
import 'package:snowscape_tracker/data/recorded_activity.dart';
import 'package:snowscape_tracker/data/recording_status.dart';
import 'package:snowscape_tracker/models/location_model.dart';
import 'package:snowscape_tracker/models/map_model.dart';
import 'package:snowscape_tracker/models/record_activity_model.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';
import 'package:snowscape_tracker/widgets/custom_app_bar.dart';
import 'package:snowscape_tracker/widgets/record_activity_container.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  bool recoveredPath = false;

  @override
  void initState() {
    super.initState();
    // we need to add the observer to the widget binding to be able to listen to the app lifecycle
    WidgetsBinding.instance.addObserver(this);

    // we need to check if the user has already started recording an activity before
    // var isRecording = UserPreferences.getRecording();

    // if the user has started recording an activity before, we need to load the recorded path
    if (UserPreferences.getRecordingStatus() != RecordingStatus.idle) {
      RecordActivityCommand()
          .recoverRecordedActivityFromSharedPreferences()
          .then((path) {
        debugPrint("path recovered from shared preferences: $path");

        // change the tracking pace to make sure that we are tracking the user's location often enough
        LocationCommand().changeTrackingPace();

        // we need to set the path to the map model
        if (path == null) return;
        setState(() {
          // if we have a path, we need to set the path to the map model when the map page is loaded
          recoveredPath = true;
        });
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    debugPrint('AppLifecycleState changed');
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    if (state == AppLifecycleState.resumed) {
      // when app is resumed we need to recover the path drawn in the meantime

      var path = await UserPreferences.getPathCoordinates();
      if (path.isNotEmpty) {
        debugPrint("path recovered from shared preferences: $path");
        RecordActivityCommand().recordActivityModel.setPoints = path;
        await MapCommand().updatePolyline(path);
      }
    }

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      // if the app is going to background
      // final isRecording = UserPreferences.getRecording();
      final isRecording =
          UserPreferences.getRecordingStatus() != RecordingStatus.idle;

      if (isRecording) {
        // save the elapsed time to shared preferences
        await RecordActivityCommand().saveElapsedTimeToSharedPreferences();

        var oldpath = RecordActivityCommand().recordActivityModel.points;
        debugPrint("path before app went to background: $oldpath");
        // if we are recording an activity, we want to save the recorded path to user preferences
        // RecordActivityCommand().saveRecordedActivityToSharedPreferences();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentLocation = context.select<LocationModel, bg.Location?>(
      (locationModel) => locationModel.currentLocation,
    );
    var recordingContainerVisible = context.select<MapModel, bool>(
      (mapModel) => mapModel.recordingContainerVisible,
    );

    // var isRecording = context.select<RecordActivityModel, bool>(
    //   (recordActivityModel) => recordActivityModel.isRecording,
    // );

    RecordingStatus recordingStatus =
        context.select<RecordActivityModel, RecordingStatus>(
      (recordActivityModel) => recordActivityModel.getRecordingStatus,
    );

    var recordedActivity =
        context.select<RecordActivityModel, RecordedActivity?>(
      (recordActivityModel) => recordActivityModel.recordedActivity,
    );

    var points = context.select<RecordActivityModel, List<LatLng>?>(
      (recordActivityModel) => recordActivityModel.points,
    );

    void handleLocationUpdate(bg.Location location) {
      // debugPrint('Location update received');
      MapCommand().updateCameraPosition(currentLocation);

      if (recordingStatus == RecordingStatus.recording &&
          recordedActivity != null &&
          points != null) {
        // update RecordedActivity's array of points only if the user is recording an activity and recordedActivity is initialized
        RecordActivityCommand().addPointToRecordedActivity(currentLocation!);

        MapCommand().updatePolyline(points);
      }
    }

    currentLocation != null
        ? handleLocationUpdate(currentLocation)
        : null; // handle location update only if the current location is not null

    void handleOnCurrentLocationPressed() {
      LocationCommand().getCurrentLocation();
    }

    void onMapCreated(MapboxMapController controller) async {
      // debugPrint('Map created');
      MapCommand().initiateMap(controller);
      if (recoveredPath &&
          RecordActivityCommand().recordActivityModel.points != null) {
        await MapCommand().updatePolyline(
            RecordActivityCommand().recordActivityModel.points!);
      }
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: CustomAppBar(),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: MapboxMap(
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
          ),
          recordingContainerVisible
              ? const RecordActivityContainer()
              : Container(), // show the recording container only if the user clicks on the record button in AppBar
        ],
      ),
      floatingActionButton: !recordingContainerVisible
          ? FloatingActionButton(
              onPressed: () {
                handleOnCurrentLocationPressed();
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.my_location_rounded),
            )
          : null,
    );
  }

  @override
  void dispose() {
    MapCommand()
        .resetController(); // added because the controller was not disposed correctly
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
