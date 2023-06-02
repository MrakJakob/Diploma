import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/models/app_model.dart';
import 'package:snowscape_tracker/models/location_model.dart';
import 'package:snowscape_tracker/models/map_model.dart';
import 'package:snowscape_tracker/models/planned_tour_model.dart';
import 'package:snowscape_tracker/models/profile_model.dart';
import 'package:snowscape_tracker/models/record_activity_model.dart';
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
import 'commands/base_command.dart' as Commands;
import 'models/home_model.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

@pragma('vm:entry-point')
void headlessTask(bg.HeadlessEvent headlessEvent) async {
  print('[BackgroundGeolocation HeadlessTask]: $headlessEvent');
  // Implement a 'case' for only those events you're interested in.
  switch (headlessEvent.name) {
    case bg.Event.LOCATION:
      bg.Location location = headlessEvent.event;
      // we need to save the location to the shared preferences when app is in background
      await UserPreferences.addPathCoordinate(
          LatLng(location.coords.latitude, location.coords.longitude));
      break;
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.init();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());

  // Register headlessTask:
  bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
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
          Provider(create: (_) => LocationService()),
          Provider(create: (_) => RecordActivityService()),
          Provider(create: (_) => MapboxService()),
        ],
        child: Builder(
          builder: (context) {
            Commands.init(context);
            return MaterialApp(
              title: 'Snowscape Tracker',
              scaffoldMessengerKey: SnackBarWidget
                  .messengerKey, // messengerKey is a static property of SnackBarWidget
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

  void initialization() async {
    UserPreferences.init();
    if (UserPreferences.isFirstLoad()) {
      UserPreferences.setFirstLoad(false);
      // TODO: here we load the initial data in the local sqlite database
    }
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
              return MainAppContainerPage();
            } else {
              return AuthPage();
            }
          }),
    );
  }
}
