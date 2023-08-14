import 'package:flutter/material.dart';

class InstructionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> planningInstructions = [
      'To plan a tour, click on the Plan button on the Map page in the top app bar. '
          'A toolbar will appear on the bottom half of the screen. ',
      'You can add waypoint markers to your tour by clicking and holding the desired location on map. ',
      'Select the date of your tour by clicking on the date placeholder in the toolbar. ',
      'Select the time of your tour by clicking on the time placeholder in the toolbar. ',
      'You can disable adding waypoint markers by turning off the "Markers" option in the toolbar.',
      'By default the route between waypoints will be calculated automatically, '
          'but you can also draw the route manually turning off the "Generate route" option in the toolbar.',
      'To undo the last added waypoint, click on the "Undo" button in the toolbar.',
      'To cancel the tour planning, click on the "Cancel" button in the toolbar.',
      'When you are done with adding waypoints, click on the "Calculate" button to calculate the elevation gain '
          'and check for avalanche danger.',
      'Once you are done, click on the "Save" button to save your tour. '
          'You can view your saved tours on the "Planned tours" page on your profile.'
    ];

    List<String> recordingInstructions = [
      'To record a tour, click on the "Record" button on the Map page in the top app bar. '
          'A toolbar will appear on the bottom half of the screen. ',
      'To start recording click on the "Start" button. '
          'The app will start recording your location. ',
      'If you don\'t want to record the tour, you can click on "Cancel" button. ',
      'You can pause the recording by clicking on the "Stop" button. ',
      'To resume recording click on the "Resume" button. ',
      'When you are done with recording, click on "Finish" button to save your tour. '
          'You will be redirected to a screen where you enter the details of your tour.',
      'If you would like to share the tour with others, turn on the switch button.',
      'If you want to discard the tour, click on the "Cancel" button. ',
      'Click on the "Save" button to save your tour. '
          'You can view your saved tours on the "My tours" page on your profile.',
    ];

    List<String> exploreInstructions = [
      'To explore the shared tours from other users, click on the "Explore" button in the bottom app bar. ',
      'You can horizontally scroll through the list of tours and view the details of the tour by clicking on the tour card. ',
      'The tour path is displayed on the map. ',
    ];

    Widget getListItem(String item, int index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          '${index + 1}. $item',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.black,
              ),
        ),
      );
    }

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
                  color: Color.fromARGB(26, 0, 0, 0),
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Instructions',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                  color: Color.fromARGB(26, 0, 0, 0),
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tour planning',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Image(
                    image: AssetImage('assets/Planning_instructions.jpg')),
                const Divider(
                  color: Color.fromARGB(26, 0, 0, 0),
                  thickness: 1,
                  height: 20,
                ),
                Column(
                    children: planningInstructions
                        .asMap()
                        .entries
                        .map((MapEntry map) => getListItem(map.value, map.key))
                        .toList()),
              ],
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
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Recording tours',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Image(
                    image: AssetImage('assets/Recording_instructions1.png')),
                const Divider(
                  color: Color.fromARGB(26, 0, 0, 0),
                  thickness: 1,
                  height: 20,
                ),
                Column(
                    children: recordingInstructions
                        .asMap()
                        .entries
                        .map((MapEntry map) {
                  if (map.key == 3) {
                    return Column(
                      children: [
                        const Image(
                            image: AssetImage(
                                'assets/Recording_instructions2.png')),
                        const Divider(
                          color: Color.fromARGB(26, 0, 0, 0),
                          thickness: 1,
                          height: 20,
                        ),
                        getListItem(map.value, map.key),
                      ],
                    );
                  } else if (map.key == 4) {
                    return Column(
                      children: [
                        const Image(
                            image: AssetImage(
                                'assets/Recording_instructions3.png')),
                        const Divider(
                          color: Color.fromARGB(26, 0, 0, 0),
                          thickness: 1,
                          height: 20,
                        ),
                        getListItem(map.value, map.key),
                      ],
                    );
                  } else if (map.key == 6) {
                    return Column(
                      children: [
                        const Image(
                            image: AssetImage(
                                'assets/Recording_instructions4.png')),
                        const Divider(
                          color: Color.fromARGB(26, 0, 0, 0),
                          thickness: 1,
                          height: 20,
                        ),
                        getListItem(map.value, map.key),
                      ],
                    );
                  }
                  return getListItem(map.value, map.key);
                }).toList())
              ],
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
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Explore tours',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Image(
                    image: AssetImage('assets/Explore_instructions1.png')),
                const Divider(
                  color: Color.fromARGB(26, 0, 0, 0),
                  thickness: 1,
                  height: 20,
                ),
                Column(
                    children: exploreInstructions
                        .asMap()
                        .entries
                        .map((MapEntry map) => getListItem(map.value, map.key))
                        .toList()),
                const Image(
                    image: AssetImage('assets/Explore_instructions2.png')),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
