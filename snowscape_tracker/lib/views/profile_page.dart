import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/logout_command.dart';
import 'package:snowscape_tracker/commands/profile_command.dart';
import 'package:snowscape_tracker/models/profile_model.dart';
import 'package:snowscape_tracker/views/saved_planned_tours_page.dart';
import 'package:snowscape_tracker/views/saved_recorded_activites_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var index =
        context.select<ProfileModel, int>((model) => model.selectedIndex);

    void switchPage(int index) {
      ProfileCommand().setPageIndex(index);
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Center(
            child: Text(
              'Profile page',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => {
              if (item == 0)
                {
                  LogoutCommand().execute(),
                }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Logout'),
                      Icon(Icons.logout, color: Colors.black),
                    ],
                  )),
            ],
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.5,
                color: Color.fromARGB(26, 0, 0, 0),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  decoration: index == 0
                      ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.5,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        )
                      : null,
                  child: TextButton(
                    onPressed: () => switchPage(0),
                    child: Text(
                      'My tours',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: index == 0
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  decoration: index == 1
                      ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.5,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        )
                      : null,
                  child: TextButton(
                    onPressed: () => switchPage(1),
                    child: Text(
                      'Planned tours',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: index == 1
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: index,
            children: const [
              SavedRecordedActivitiesPage(),
              SavedPlannedToursPage(),
            ],
          ),
        ),
      ]),
    );
  }
}
