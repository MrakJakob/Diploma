import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snowscape_tracker/commands/location_command.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/record_activity_command.dart';
import 'package:snowscape_tracker/models/record_activity_model.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';

class RecordActivityContainer extends StatefulWidget {
  const RecordActivityContainer({super.key});

  @override
  State<RecordActivityContainer> createState() =>
      _RecordActivityContainerState();
}

class _RecordActivityContainerState extends State<RecordActivityContainer> {
  Timer? timer;
  int elapsedTimeInSeconds = 0;

  @override
  void initState() {
    super.initState();

    // we need to check if the user is recording an activity and if so, we need to calculate the elapsed time and start the timer to update the duration in UI
    if (RecordActivityCommand().recordActivityModel.isRecording) {
      UserPreferences.getActivityStartTime().then((startTime) {
        // debugPrint("start time: $startTime");
        var elapsedTimeSeconds = DateTime.now().difference(startTime).inSeconds;

        RecordActivityCommand().setActivityDuration(elapsedTimeSeconds.toInt());

        timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
          RecordActivityCommand().incrementActivityDuration();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isRecording =
        context.select<RecordActivityModel, bool>((model) => model.isRecording);

    double distance = context.select<RecordActivityModel, double>(
      (model) => model.distance,
    );

    double averageSpeed = context.select<RecordActivityModel, double>(
      (model) => model.averageSpeed,
    );

    int duration = context.select<RecordActivityModel, int>(
      (model) => model.getDuration,
    );

    void startRecording() {
      RecordActivityCommand()
          .startRecording(); // we need to start recording to create RecordedActivity object
      LocationCommand()
          .changeTrackingPace(); // we need to change the tracking pace to get instant location updates

      // we set
      timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        RecordActivityCommand().incrementActivityDuration();
        // we update the duration every second
      });
    }

    void stopRecording() {
      timer?.cancel(); // stop the timer
      RecordActivityCommand().stopRecording();
      LocationCommand().changeTrackingPace();
    }

    void cancelRecordSession() {
      MapCommand().hideRecordingContainer();
      UserPreferences
          .clearSharedPrefs(); // TODO: change when we have a better solution for storing the recorded activities
    }

    String printDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }

    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Time',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      printDuration(Duration(seconds: duration)),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            color: Color.fromARGB(26, 0, 0, 0),
            thickness: 1,
            height: 0,
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Distance (km)',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            distance.toStringAsFixed(2),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      width: 20,
                      color: Color.fromARGB(26, 0, 0, 0),
                      thickness: 1,
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'AVG Speed (km/h)',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            averageSpeed.toStringAsFixed(2),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            color: Color.fromARGB(26, 0, 0, 0),
            thickness: 1,
            height: 0,
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        !isRecording
                            ? {cancelRecordSession()}
                            : null; // if we are not recording, we can hide the recording container when user clicks on cancel
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Cancel",
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      !isRecording ? startRecording() : stopRecording();
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        !isRecording ? "Start" : "Stop",
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
