import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/logout_command.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:snowscape_tracker/commands/planned_tour_command.dart';
import 'package:snowscape_tracker/commands/record_activity_command.dart';
import 'package:snowscape_tracker/data/recording_status.dart';
import 'package:snowscape_tracker/helpers/alert_dialog.dart';
import 'package:snowscape_tracker/models/planned_tour_model.dart';
import 'package:snowscape_tracker/models/record_activity_model.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RecordingStatus recordingStatus =
        context.select<RecordActivityModel, RecordingStatus>(
      (recordActivityModel) => recordActivityModel.getRecordingStatus,
    );

    bool isTourPlanning = context.select<PlannedTourModel, bool>(
      (plannedTourModel) => plannedTourModel.isTourPlanning,
    );

    void showRecordingContainer() {
      if (isTourPlanning) {
        showAlertDialog(
          context,
          'You are currently planning a tour',
          'Do you want to discard the tour?',
          () async {
            PlannedTourCommand().stopTourPlanning();
            MapCommand().stopTourPlanning();

            MapCommand().showRecordingContainer();
            Navigator.of(context).pop();
          },
          () {
            Navigator.of(context).pop();
          },
        );
        return;
      } else {
        MapCommand().showRecordingContainer();
      }
    }

    void showTourPlanningContainer() {
      if (recordingStatus == RecordingStatus.recording ||
          recordingStatus == RecordingStatus.paused) {
        showAlertDialog(
          context,
          'You are currently recording a tour',
          'Do you want to discard the tour?',
          () async {
            await RecordActivityCommand().endRecordedActivity();
            await MapCommand().clearMap();
            UserPreferences.clearRecordedActivity();
            MapCommand().showTourPlanningContainer();
            Navigator.of(context).pop();
          },
          () {
            Navigator.of(context).pop();
          },
        );
        return;
      }

      MapCommand().showTourPlanningContainer();
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
            onPressed: () {
              showTourPlanningContainer();
            },
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
