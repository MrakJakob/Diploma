import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/app_command.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:snowscape_tracker/commands/planned_tour_command.dart';
import 'package:snowscape_tracker/commands/record_activity_command.dart';
import 'package:snowscape_tracker/data/recording_status.dart';
import 'package:snowscape_tracker/helpers/alert_dialog.dart';
import 'package:snowscape_tracker/models/app_model.dart';
import 'package:snowscape_tracker/models/planned_tour_model.dart';
import 'dart:io' show Platform;

import 'package:snowscape_tracker/models/record_activity_model.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';

class MainAppContainerPage extends StatelessWidget {
  const MainAppContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget selectedPage =
        context.select<AppModel, Widget>((model) => model.selectedPage);

    bool isTourPlanning = context.select<PlannedTourModel, bool>(
      (plannedTourModel) => plannedTourModel.isTourPlanning,
    );

    bool isRecording = context.select<RecordActivityModel, bool>(
      (recordActivityModel) =>
          recordActivityModel.getRecordingStatus != RecordingStatus.idle,
    );

    int selectedPageIndex = context.select<AppModel, int>(
      (model) => model.selectedPageIndex,
    );

    void setSelectedPage(int pageIndex) {
      if (pageIndex != 0) {
        if (isTourPlanning) {
          showAlertDialog(
            context,
            'You are currently planning a tour',
            'Do you want to discard the tour?',
            () async {
              PlannedTourCommand().stopTourPlanning();
              await MapCommand().stopTourPlanning();

              Navigator.of(context).pop();
              AppCommand().switchMainPage(pageIndex);
            },
            () {
              Navigator.of(context).pop();
            },
          );
        } else if (isRecording) {
          showAlertDialog(
            context,
            'You are currently recording a tour',
            'Do you want to discard the tour?',
            () async {
              await RecordActivityCommand().endRecordedActivity();
              await MapCommand().clearMap();
              UserPreferences.clearRecordedActivity();
              AppCommand().switchMainPage(pageIndex);
              Navigator.of(context).pop();
            },
            () {
              Navigator.of(context).pop();
            },
          );
          return;
        } else {
          AppCommand().switchMainPage(pageIndex);
        }
      } else {
        AppCommand().switchMainPage(pageIndex);
      }
    }

    return Scaffold(
      body: selectedPage,
      bottomNavigationBar: BottomAppBar(
        height: Platform.isIOS ? 90 : 70,
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: GestureDetector(
                onTap: () {
                  setSelectedPage(0);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      TablerIcons.compass,
                      size: 28,
                      color: selectedPageIndex == 0
                          ? Theme.of(context).secondaryHeaderColor
                          : Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Map',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: selectedPageIndex == 0
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
                  setSelectedPage(1);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      TablerIcons.search,
                      size: 28,
                      color: selectedPageIndex == 1
                          ? Theme.of(context).secondaryHeaderColor
                          : Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Explore',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: selectedPageIndex == 1
                                ? Theme.of(context).secondaryHeaderColor
                                : Colors.white.withOpacity(0.7),
                          ),
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
                  setSelectedPage(2);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      TablerIcons.user_circle,
                      size: 28,
                      color: selectedPageIndex == 2
                          ? Theme.of(context).secondaryHeaderColor
                          : Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: selectedPageIndex == 2
                                ? Theme.of(context).secondaryHeaderColor
                                : Colors.white.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
