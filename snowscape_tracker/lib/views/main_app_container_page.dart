import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/app_command.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:snowscape_tracker/commands/planned_tour_command.dart';
import 'package:snowscape_tracker/helpers/alert_dialog.dart';
import 'package:snowscape_tracker/models/app_model.dart';
import 'package:snowscape_tracker/models/planned_tour_model.dart';

class MainAppContainerPage extends StatelessWidget {
  const MainAppContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget selectedPage =
        context.select<AppModel, Widget>((model) => model.selectedPage);

    bool isTourPlanning = context.select<PlannedTourModel, bool>(
      (plannedTourModel) => plannedTourModel.isTourPlanning,
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
        height: 60,
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
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
            GestureDetector(
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
            GestureDetector(
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
          ],
        ),
      ),
    );
  }
}
