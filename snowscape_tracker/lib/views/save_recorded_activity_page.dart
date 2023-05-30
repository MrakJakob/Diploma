import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:snowscape_tracker/commands/record_activity_command.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';

class SaveRecordedActivityPage extends StatefulWidget {
  const SaveRecordedActivityPage({Key? key}) : super(key: key);

  @override
  State<SaveRecordedActivityPage> createState() =>
      _SaveRecordedActivityPageState();
}

class _SaveRecordedActivityPageState extends State<SaveRecordedActivityPage> {
  @override
  Widget build(BuildContext context) {
    void saveTour() async {
      // we save the tour and then pop the save recorded activity page
      RecordActivityCommand().saveRecordedActivity().then((success) async {
        Navigator.of(context).pop();
        if (success) {
          // we clear the map
          await MapCommand().clearMap();
          // and clear the recorded activity from the shared preferences
          UserPreferences.clearSharedPrefs();
        }
      });
    }

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: Center(
              child: Text(
                'Save Tour',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Tour Name',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller:
                              RecordActivityCommand().tourNameController(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                color: Color.fromARGB(25, 0, 0, 0),
                              ),
                            ),
                            labelText: 'Enter a name for your tour',
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: RecordActivityCommand()
                              .tourDescriptionController(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter a description for your tour',
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Tour Difficulty',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (difficulty) {
                            RecordActivityCommand()
                                .setDifficulty(difficulty.toInt());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                  width: 2.0,
                                  color: Theme.of(context).primaryColor)),
                          child: Text(
                            'Cancel',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            saveTour();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
