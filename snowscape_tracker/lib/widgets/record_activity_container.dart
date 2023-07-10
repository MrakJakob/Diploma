import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snowscape_tracker/commands/location_command.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/record_activity_command.dart';
import 'package:snowscape_tracker/data/recording_status.dart';
import 'package:snowscape_tracker/helpers/formating.dart';
import 'package:snowscape_tracker/models/record_activity_model.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';
import 'package:snowscape_tracker/views/save_recorded_activity_page.dart';

class RecordActivityContainer extends StatefulWidget {
  const RecordActivityContainer({super.key});

  @override
  State<RecordActivityContainer> createState() =>
      _RecordActivityContainerState();
}

class _RecordActivityContainerState extends State<RecordActivityContainer> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    var recordingStatus = UserPreferences.getRecordingStatus();
    // we need to check if the user is recording an activity and if so, we need to calculate the elapsed time and start the timer to update the duration in UI
    if (recordingStatus != RecordingStatus.idle) {
      // UserPreferences.getActivityElapsedTime().then((elapsedTimeSeconds) {
      //   // var elapsedTimeSeconds = DateTime.now().difference(startTime).inSeconds;

      //   RecordActivityCommand().setActivityDuration(elapsedTimeSeconds);

      //   if (recordingStatus == RecordingStatus.recording) {
      //     // we need to start the timer to update the duration in UI
      //     timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      //       RecordActivityCommand().incrementActivityDuration();
      //     });
      //   }
      // });
    }

    if (recordingStatus == RecordingStatus.recording) {
      // we need to start the timer to update the duration in UI
      timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        RecordActivityCommand().incrementActivityDuration();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool isRecording =
    //     context.select<RecordActivityModel, bool>((model) => model.isRecording);
    RecordingStatus recordingStatus =
        context.select<RecordActivityModel, RecordingStatus>(
            (model) => model.getRecordingStatus);

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
      // clear the recorded activity from shared prefs
      UserPreferences.clearRecordedActivity();
    }

    void resumeRecording() {
      RecordActivityCommand().resumeRecording();
      LocationCommand().changeTrackingPace();
      timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        RecordActivityCommand().incrementActivityDuration();
      });
    }

    void finishRecording() {
      // open screen to save the activity

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SaveRecordedActivityPage()),
      );
      // RecordActivityCommand().finishRecording();
      // UserPreferences.clearSharedPrefs();
    }

    void handleRecordingClick() {
      switch (recordingStatus) {
        case RecordingStatus.idle:
          startRecording();
          break;
        case RecordingStatus.recording:
          stopRecording();
          break;
        case RecordingStatus.paused:
          finishRecording();
          break;
        default:
          break;
      }
    }

    void handleResumeCancelClick() {
      switch (recordingStatus) {
        case RecordingStatus.idle:
          cancelRecordSession();
          break;
        case RecordingStatus.paused:
          resumeRecording();
          break;
        default:
          break;
      }
    }

    return Flexible(
      flex: 8,
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
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Text(
                        'Time',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.loose,
                      child: Text(
                        printDuration(Duration(seconds: duration), false),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
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
                          Flexible(
                            flex: 1,
                            fit: FlexFit.loose,
                            child: Text(
                              'Distance (km)',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: Text(
                              distance.toStringAsFixed(2),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
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
                          Flexible(
                            flex: 1,
                            fit: FlexFit.loose,
                            child: Text(
                              'AVG Speed (km/h)',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: Text(
                              averageSpeed.toStringAsFixed(2),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                recordingStatus != RecordingStatus.recording
                    ? Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: GestureDetector(
                          onTap: () {
                            handleResumeCancelClick();
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
                              recordingStatus == RecordingStatus.idle
                                  ? "Cancel"
                                  : "Resume",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                recordingStatus != RecordingStatus.recording
                    ? const Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: SizedBox(
                          width: 20,
                        ),
                      )
                    : Container(),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: GestureDetector(
                    onTap: () {
                      handleRecordingClick();
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
                        recordingStatus == RecordingStatus.idle
                            ? "Start"
                            : recordingStatus == RecordingStatus.recording
                                ? "Stop"
                                : "Finish",
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
