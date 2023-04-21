import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/views/home_page.dart';
import 'commands/base_command.dart' as Commands;
import 'models/home_model.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeModel()),
        ],
        child: Builder(
          builder: (context) {
            Commands.init(context);
            return MaterialApp(
              title: 'Snowscape Tracker',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const HomePage(),
            );
          },
        ));
  }
}
