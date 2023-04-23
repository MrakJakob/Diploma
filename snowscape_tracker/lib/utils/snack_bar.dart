import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/models/app_model.dart';

class SnackBarWidget {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static show(
    String? message,
  ) {
    if (message == null) return;

    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
