import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:snowscape_tracker/commands/planned_tour_command.dart';
import 'package:snowscape_tracker/constants/format_date.dart';
import 'package:snowscape_tracker/data/planned_tour.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';

class SavedPlannedToursPage extends StatelessWidget {
  const SavedPlannedToursPage({super.key});

  @override
  Widget build(BuildContext context) {
    var displayName = UserPreferences.getDisplayName();

    return FutureBuilder(
      future: PlannedTourCommand().getPlannedToursFromDatabase(),
      builder: (context, AsyncSnapshot<List<PlannedTour>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: () {
                      PlannedTourCommand()
                          .loadSavedTourToMap(snapshot.data![index]);
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
                      child: Column(children: [
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
                                    child: const Image(
                                      image: AssetImage("assets/mountain.png"),
                                    )),
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
                                      // TODO: implement date of tour
                                      FormatDate().f.format(snapshot
                                          .data![index].plannedTourTime),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data![index].tourName,
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
                                      displayName,
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
                      ]),
                    ),
                  ),
                );
              });
        }
      },
    );
  }
}
