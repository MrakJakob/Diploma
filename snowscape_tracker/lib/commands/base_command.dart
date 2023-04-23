import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/models/app_model.dart';
import 'package:snowscape_tracker/models/home_model.dart';
import 'package:snowscape_tracker/services/user_service.dart';

late BuildContext _mainContext;

// The commands will use this to access the Provided models and services.
void init(BuildContext context) => _mainContext = context;

// Provide quick lookup methods for all the top-level models and services. Keeps the Command code slightly cleaner.
class BaseCommand {
  // Models
  HomeModel homeModel = _mainContext.read<HomeModel>();
  AppModel appModel = _mainContext.read<AppModel>();

  // Services
  UserService userService = _mainContext.read<UserService>();
}
