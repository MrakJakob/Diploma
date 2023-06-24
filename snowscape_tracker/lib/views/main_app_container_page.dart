import 'package:flutter/material.dart';
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
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.map),
                onPressed: () {
                  setSelectedPage(0);
                },
                iconSize: 38,
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
                iconSize: 38,
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(
                  Icons.person,
                ),
                onPressed: () {
                  setSelectedPage(1);
                },
                iconSize: 38,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
