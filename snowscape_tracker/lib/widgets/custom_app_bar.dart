import 'package:flutter/material.dart';
import 'package:snowscape_tracker/commands/logout_command.dart';
import 'package:snowscape_tracker/commands/map_command.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void showRecordingContainer() {
      MapCommand().showRecordingContainer();
    }

    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(
              Icons.route,
              color: Colors.white,
            ),
            iconSize: 38,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.radio_button_checked,
              color: Colors.white,
            ),
            iconSize: 38,
            onPressed: () {
              showRecordingContainer();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            iconSize: 38,
            onPressed: () {
              // TODO: implement notifications
              // this is temporary
              LogoutCommand().execute();
            },
          ),
        ],
      ),
    );
  }
}
