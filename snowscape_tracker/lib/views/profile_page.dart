import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/profile_command.dart';
import 'package:snowscape_tracker/models/profile_model.dart';
import 'package:snowscape_tracker/views/saved_recorded_activites_page.dart';

class ProfilePage extends StatelessWidget {
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
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      : null,
                  child: TextButton(
                    onPressed: () => switchPage(0),
                    child: Text(
                      'Saved tours',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      : null,
                  child: TextButton(
                    onPressed: () => switchPage(1),
                    child: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
              Text('Settings page'),
            ],
          ),
        ),
      ]),
    );
  }
}
