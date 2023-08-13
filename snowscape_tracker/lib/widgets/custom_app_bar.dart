import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/logout_command.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:snowscape_tracker/commands/planned_tour_command.dart';
import 'package:snowscape_tracker/commands/record_activity_command.dart';
import 'package:snowscape_tracker/data/recording_status.dart';
import 'package:snowscape_tracker/helpers/alert_dialog.dart';
import 'package:snowscape_tracker/models/map_model.dart';
import 'package:snowscape_tracker/models/planned_tour_model.dart';
import 'package:snowscape_tracker/models/record_activity_model.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';
import 'package:snowscape_tracker/views/instructions_page.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    RecordingStatus recordingStatus =
        context.select<RecordActivityModel, RecordingStatus>(
      (recordActivityModel) => recordActivityModel.getRecordingStatus,
    );

    bool isTourPlanning = context.select<PlannedTourModel, bool>(
      (plannedTourModel) => plannedTourModel.isTourPlanning,
    );

    String selectedFunctionality = context.select<MapModel, String>(
      (recordActivityModel) => recordActivityModel.selectedFunctionality,
    );

    void showRecordingContainer() {
      if (isTourPlanning) {
        showAlertDialog(
          context,
          'You are currently planning a tour',
          'Do you want to discard the tour?',
          () async {
            PlannedTourCommand().stopTourPlanning();
            await MapCommand().stopTourPlanning();

            MapCommand().showRecordingContainer();
            Navigator.of(context).pop();
          },
          () {
            PlannedTourCommand().setAddMarkers(false);
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
            MapCommand().showTourPlanningContainer("start");
            Navigator.of(context).pop();
          },
          () {
            Navigator.of(context).pop();
          },
        );
        return;
      }

      MapCommand().showTourPlanningContainer("start");
    }

    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                showTourPlanningContainer();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    TablerIcons.route,
                    color: selectedFunctionality == 'plan'
                        ? Theme.of(context).secondaryHeaderColor
                        : Colors.white.withOpacity(0.7),
                    size: 28,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Plan',
                    style: TextStyle(
                      color: selectedFunctionality == 'plan'
                          ? Theme.of(context).secondaryHeaderColor
                          : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => InstructionsPage(),
                ));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/mountain.png'),
                    width: 38,
                    height: 38,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                showRecordingContainer();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    TablerIcons.circle_dot,
                    color: selectedFunctionality == 'record'
                        ? Theme.of(context).secondaryHeaderColor
                        : Colors.white.withOpacity(0.7),
                    size: 28,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Record',
                    style: TextStyle(
                      color: selectedFunctionality == 'record'
                          ? Theme.of(context).secondaryHeaderColor
                          : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     LogoutCommand().execute();
          //   },
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Icon(
          //         TablerIcons.logout,
          //         color: Colors.white.withOpacity(0.7),
          //         size: 28,
          //       ),
          //       SizedBox(height: 5),
          //       Text(
          //         'Log out',
          //         style: TextStyle(
          //           color: Colors.white.withOpacity(0.7),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
