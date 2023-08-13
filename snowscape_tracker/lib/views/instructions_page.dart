import 'package:flutter/material.dart';

class InstructionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Center(
            child: Text(
              'Snowscape Tracker',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Instructions',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'This app is designed to help you track your snow activities. '
              'You can record your activities, plan your tours, and explore tours of other users. ',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tour planning',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'To plan a tour, click on the Plan button on the Map page in the top app bar. '
              'A toolbar will appear on the bottom half of the screen. '
              'You can add waypoint markers to your tour by clicking and holding the desired location on map. '
              'By default the route between waypoints will be calculated automatically, '
              'but you can also draw the route manually turning off the "Generate route" option in the toolbar.'
              'You can also disable adding waypoint markers by turning off the "Markers" option in the toolbar.'
              'When you are done with adding waypoints, click on the "Calculate" button to calculate the elevation gain'
              'and check for avalanche danger.'
              'Once you are done, click on the "Save" button to save your tour. '
              'You can view your saved tours on the "Planned tours" page on your profile.',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Recording tours',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'To record a tour, click on the "Record" button on the Map page in the top app bar. '
              'A toolbar will appear on the bottom half of the screen. '
              'To start recording click on the "Start" button. '
              'The app will start recording your location. '
              'You can pause the recording by clicking on the "Stop" button. '
              'To resume recording click on the "Resume" button. '
              'When you are done with recording, click on the "Stop" and then "Finish" button to save your tour.'
              'You will be redirected to a screen where you enter the details of your tour.'
              'If you would like to share the tour with others, turn on the switch button.'
              'You can view your saved tours on the "My tours" page on your profile.',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
        ]),
      ),
    );
  }
}
