import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/data/bulletin/avalanche_bulletin.dart';
import 'package:snowscape_tracker/data/bulletin/danger_bulletin.dart';
import 'package:snowscape_tracker/data/bulletin/pattern_bulletin.dart';
import 'package:snowscape_tracker/data/bulletin/problem_bulletin.dart';
import 'package:snowscape_tracker/data/plannedTourDb/planned_tour_db.dart';
import 'package:snowscape_tracker/data/plannedTourDb/route_point_db.dart';
import 'package:snowscape_tracker/data/planned_tour.dart';
import 'package:snowscape_tracker/data/rules/danger_rule.dart';
import 'package:snowscape_tracker/data/rules/jsonObjects/rules_json.dart';
import 'package:snowscape_tracker/data/rules/matched_rule.dart';
import 'package:snowscape_tracker/data/rules/pattern_rule.dart';
import 'package:snowscape_tracker/data/rules/problem_rule.dart';
import 'package:snowscape_tracker/data/rules/rule.dart';
import 'package:snowscape_tracker/data/rules/weather_description.dart';
import 'package:snowscape_tracker/data/weather/weather_hour.dart';
import 'package:snowscape_tracker/models/app_model.dart';
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
import 'package:snowscape_tracker/theme/custom_theme.dart';
import 'package:snowscape_tracker/utils/snack_bar.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';
import 'package:snowscape_tracker/views/auth_page.dart';
import 'package:snowscape_tracker/views/main_app_container_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'commands/base_command.dart' as Commands;
import 'models/home_model.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:path/path.dart';

@pragma('vm:entry-point')
void headlessTask(bg.HeadlessEvent headlessEvent) async {
  print('[BackgroundGeolocation HeadlessTask]: $headlessEvent');

  switch (headlessEvent.name) {
    case bg.Event.LOCATION:
      bg.Location location = headlessEvent.event;
      // we need to save the location to the shared preferences when app is in detached mode
      await UserPreferences.addPathCoordinate(
          LatLng(location.coords.latitude, location.coords.longitude));
      break;
  }
}

Future<void> populateDatabase(Database db) async {
  var uuid = const Uuid();

  final String response = await rootBundle.loadString('assets/rules.json');
  if (response.contains('error')) {
    throw Exception('Failed to load rules');
  }
  final data = await json.decode(response);
  if (data == null) {
    throw Exception('Failed to load rules');
  }

  RulesJson rules = RulesJson.fromJson(data);

  var index = 1;

  for (var rule in rules.rules!) {
    Rule dbRule = Rule(
        ruleId: index,
        aspect: rule.aspect,
        minSlope: rule.minSlope,
        maxSlope: rule.maxSlope,
        elevationMin: rule.elevationMin,
        elevationMax: rule.elevationMax,
        hourMin: rule.hourMin,
        hourMax: rule.hourMax,
        userHiking: rule.userHiking,
        avAreaId: rule.avAreaId,
        notificationName: rule.notificationName,
        notificationText: rule.notificationText);
    // rule.ruleId = index;

    var rule1 = await db.insert(
      'rule',
      dbRule.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (rule.weatherDescriptions != null) {
      for (var wd in rule.weatherDescriptions!) {
        var wdId = uuid.v4();

        WeatherDescription weatherDescription = WeatherDescription(
          weatherDescriptionId: wdId,
          ruleId: rule1,
          dayDelay: wd!.dayDelay,
          tempAvgMin: wd.tempAvgMin,
          tempAvgMax: wd.tempAvgMax,
          hourMin: wd.hourMin,
          hourMax: wd.hourMax,
          oblacnost: wd.oblacnost,
          vremenskiPojav: wd.vremenskiPojav,
          intenzivnost: wd.intenzivnost,
          elevation: wd.elevation,
        );
        await db.insert(
          'weather_description_rule',
          weatherDescription.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    if (rule.patterns != null) {
      for (var pattern in rule.patterns!) {
        var pId = uuid.v4();

        PatternRule dbPattern = PatternRule(
          patternId: pId,
          ruleId: rule1,
          dayDelay: pattern?.dayDelay,
          hourMin: pattern?.hourMin,
          hourMax: pattern?.hourMax,
          patternType: pattern?.patternId,
        );
        await db.insert(
          'pattern_rule',
          dbPattern.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    if (rule.problems != null) {
      for (var problem in rule.problems!) {
        var prId = uuid.v4();

        ProblemRule dbProblem = ProblemRule(
          problemId: prId,
          ruleId: rule1,
          dayDelay: problem?.dayDelay,
          hourMin: problem?.hourMin,
          hourMax: problem?.hourMax,
          problemType: problem?.problemId,
          checkElevation: problem?.checkElevation,
        );
        await db.insert(
          'problem_rule',
          dbProblem.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    if (rule.dangers != null) {
      for (var danger in rule.dangers!) {
        var dId = uuid.v4();

        DangerRule dbDanger = DangerRule(
          dangerId: dId,
          ruleId: rule1,
          dayDelay: danger?.dayDelay,
          checkElevation: danger?.checkElevation,
          am: danger?.am,
          value: danger?.value,
        );
        await db.insert(
          'danger_rule',
          dbDanger.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    index++;
  }
}

Future<void> deleteDatabase(String path) =>
    databaseFactory.deleteDatabase(path);

Future main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.init();
  await dotenv.load(fileName: ".env");

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await deleteDatabase(join(await getDatabasesPath(), 'rules_database.db'));
  final database = await openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'rules_database.db'),
    version: 1,
    onCreate: (db, version) async {
      // Run the CREATE TABLE statement on the database.
      await db.execute(Rule.createTable());
      await db.execute(WeatherDescription.createTable());
      await db.execute(WeatherHour.createTable());
      await db.execute(PatternRule.createTable());
      await db.execute(ProblemRule.createTable());
      await db.execute(DangerRule.createTable());
      await db.execute(AvalancheBulletin.createTable());
      await db.execute(DangerBulletin.createTable());
      await db.execute(PatternBulletin.createTable());
      await db.execute(ProblemBulletin.createTable());
      await db.execute(PlannedTourDb.createTable());
      await db.execute(MatchedRule.createTable());
      await db.execute(Marker.createTable());
      await db.execute(RoutePointDb.createTable());
    },
  );

  runApp(const MyApp());

  // Register headlessTask:
  bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);

  // first time the app is loaded, we need to populate the database with the rules
  if (UserPreferences.isFirstLoad()) {
    UserPreferences.setFirstLoad(false);
    // TODO: here we load the initial data in the local sqlite database

    await populateDatabase(database);
  }

  DateTime todaysDate =
      DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  String lastAdded = UserPreferences.getWeatherLastUpdate();

  var todaysDateFormated = DateFormat('dd-MM-yyyy').format(todaysDate);
  // if we have not updated the weather and avalanche data today, we need to update it
  if (lastAdded != todaysDateFormated) {
    // Get weather data for the next 3 days and save it to the local database if it is not already there for today

    // Get avalanche forecast data for the next days and save it to the local database if it is not already there for today
    bool? avSuccess = await ArsoWeatherService().getAvalancheBulletin(database);
    bool wSuccess = await ArsoWeatherService().getWeatherForecast(database);
    if (avSuccess != null && avSuccess && wSuccess) {
      UserPreferences.setWeatherLastUpdate(todaysDate);
    }
  }

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeModel()),
          ChangeNotifierProvider(create: (_) => AppModel()),
          ChangeNotifierProvider(create: (_) => MapModel()),
          ChangeNotifierProvider(create: (_) => LocationModel()),
          ChangeNotifierProvider(create: (_) => RecordActivityModel()),
          ChangeNotifierProvider(create: (_) => ProfileModel()),
          ChangeNotifierProvider(create: (_) => PlannedTourModel()),
          Provider(create: (_) => UserService()),
          Provider(create: (_) => RecordActivityService()),
          Provider(create: (_) => MapboxService()),
          Provider(create: (_) => ArcGISService()),
          Provider(create: (_) => ArsoWeatherService()),
          Provider(create: (_) => LocationService()),
        ],
        child: Builder(
          builder: (context) {
            Commands.init(context);
            return MaterialApp(
              title: 'Snowscape Tracker',
              scaffoldMessengerKey: SnackBarWidget
                  .messengerKey, // messengerKey is a static property of SnackBarWidget
              debugShowCheckedModeBanner: false,
              theme: CustomTheme.lightTheme,
              home: MainPage(),
            );
          },
        ));
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance
              .authStateChanges(), // authStateChanges() is a method of FirebaseAuth used to listen to authentication state changes
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            } else if (snapshot.hasData) {
              return const MainAppContainerPage();
            } else {
              return AuthPage();
            }
          }),
    );
  }
}
