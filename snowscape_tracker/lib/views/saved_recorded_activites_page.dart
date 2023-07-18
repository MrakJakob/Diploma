import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:snowscape_tracker/commands/profile_command.dart';
import 'package:snowscape_tracker/constants/format_date.dart';
import 'package:snowscape_tracker/utils/snack_bar.dart';
import 'package:snowscape_tracker/views/recorded_activity_details.dart';

class SavedRecordedActivitiesPage extends StatefulWidget {
  const SavedRecordedActivitiesPage({super.key});

  @override
  State<SavedRecordedActivitiesPage> createState() =>
      _SavedRecordedActivitiesPageState();
}

class _SavedRecordedActivitiesPageState
    extends State<SavedRecordedActivitiesPage> {
  bool? internetConnection;

  Future<void> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      SnackBarWidget.show("No internet connection", null);
      setState(() {
        internetConnection = false;
      });
    } else {
      setState(() {
        internetConnection = true;
      });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    internetConnection == null ? checkConnectivity() : null;

    return StreamBuilder(
      stream: ProfileCommand().readRecordedSessions(),
      builder: (context, recordedActivity) {
        if (recordedActivity.hasError) {
          return Text(recordedActivity.error.toString());
        } else if (recordedActivity.hasData) {
          debugPrint("recorded activity:${recordedActivity.data}");
          return ListView.builder(
            itemCount: recordedActivity.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RecordedActivityDetails(
                            recordedActivity.data![index],
                            "private_from_saved_tours"),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // image in background with text on top
                            SizedBox(
                              height: 180,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                  ),
                                  child: const Center(
                                    child: Image(
                                      image: AssetImage("assets/mountain.png"),
                                      width: 140,
                                      height: 140,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // text on top of image
                            Positioned(
                              top: 15,
                              left: 15,
                              child: Container(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      FormatDate().f.format(recordedActivity
                                          .data![index].startTime),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      recordedActivity.data![index].tourName,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // text below image
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(TablerIcons.user_circle),
                                    const SizedBox(width: 6),
                                    Text(
                                      recordedActivity.data![index].userName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
