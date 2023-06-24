import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/models/app_model.dart';
import 'package:snowscape_tracker/models/home_model.dart';
import 'package:snowscape_tracker/models/location_model.dart';
import 'package:snowscape_tracker/models/map_model.dart';
import 'package:snowscape_tracker/models/planned_tour_model.dart';
import 'package:snowscape_tracker/models/profile_model.dart';
import 'package:snowscape_tracker/models/record_activity_model.dart';
import 'package:snowscape_tracker/services/arcGIS_service.dart';
import 'package:snowscape_tracker/services/arso_weather_service.dart';
import 'package:snowscape_tracker/services/location_service.dart';
import 'package:snowscape_tracker/services/mapbox_service.dart';
import 'package:snowscape_tracker/services/record_activity_service.dart';
import 'package:snowscape_tracker/services/user_service.dart';

late BuildContext _mainContext;

// The commands will use this to access the Provided models and services.
void init(BuildContext context) => _mainContext = context;

// Provide quick lookup methods for all the top-level models and services. Keeps the Command code slightly cleaner.
class BaseCommand {
  // Models
  HomeModel homeModel = _mainContext.read<HomeModel>();
  AppModel appModel = _mainContext.read<AppModel>();
  MapModel mapModel = _mainContext.read<MapModel>();
  LocationModel locationModel = _mainContext.read<LocationModel>();
  RecordActivityModel recordActivityModel =
      _mainContext.read<RecordActivityModel>();
  ProfileModel profileModel = _mainContext.read<ProfileModel>();
  PlannedTourModel plannedTourModel = _mainContext.read<PlannedTourModel>();

  // Services
  UserService userService = _mainContext.read<UserService>();
  LocationService locationService = _mainContext.read<LocationService>();
  RecordActivityService recordedActivityService =
      _mainContext.read<RecordActivityService>();
  MapboxService mapBoxService = _mainContext.read<MapboxService>();
  ArcGISService arcGISService = _mainContext.read<ArcGISService>();
  ArsoWeatherService arsoWeatherService =
      _mainContext.read<ArsoWeatherService>();
}
