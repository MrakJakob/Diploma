import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/models/profile_model.dart';
import 'package:snowscape_tracker/views/saved_recorded_activites_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var index =
        context.select<ProfileModel, int>((model) => model.selectedIndex);

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
      body: index == 0 ? SavedRecordedActivitesPage() : Text("Coming Soon"),
    );
  }
}
