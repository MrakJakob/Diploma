import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:snowscape_tracker/commands/planned_tour_command.dart';
import 'package:snowscape_tracker/data/planned_tour.dart';
import 'package:snowscape_tracker/data/rules/matched_rule.dart';
import 'package:snowscape_tracker/helpers/formating.dart';
import 'package:snowscape_tracker/models/planned_tour_model.dart';
import 'package:snowscape_tracker/utils/snack_bar.dart';
import 'package:snowscape_tracker/views/save_planned_tour.dart';

class TourPlanningContainer extends StatefulWidget {
  const TourPlanningContainer({super.key});

  @override
  State<TourPlanningContainer> createState() => _TourPlanningContainerState();
}

class _TourPlanningContainerState extends State<TourPlanningContainer> {
  DateTime plannedTourTime =
      PlannedTourCommand().getPlannedTourTime() ?? DateTime.now();
  bool? internetConnection;

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: plannedTourTime,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 3)),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
              ),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != plannedTourTime) {
      setState(() {
        plannedTourTime = picked;
      });
      PlannedTourCommand().setPlannedTourTime(picked);
    }

    return;
  }

  Future<void> pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(plannedTourTime),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme:
                  ColorScheme.light(primary: Theme.of(context).primaryColor),
            ),
            child: child!,
          );
        });
    if (picked != null) {
      setState(() {
        plannedTourTime = DateTime(
          plannedTourTime.year,
          plannedTourTime.month,
          plannedTourTime.day,
          picked.hour,
          picked.minute,
        );
      });
      PlannedTourCommand().setPlannedTourTime(plannedTourTime);
    }

    return;
  }

  Future<void> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      SnackBarWidget.show("No internet connection", null);
      setState(() {
        internetConnection = false;
      });
      PlannedTourCommand().setDrawStraightLine(true);
    } else {
      setState(() {
        internetConnection = true;
      });
      PlannedTourCommand().setDrawStraightLine(false);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    internetConnection ?? checkConnectivity();

    double? distance = context.select<PlannedTourModel, double?>(
      (model) => model.distance,
    );

    double? duration = context.select<PlannedTourModel, double?>(
      (model) => model.duration,
    );

    bool drawStraightLine = context.select<PlannedTourModel, bool>(
      (model) => model.drawStraightLine,
    );

    double? totalElevationGain = context.select<PlannedTourModel, double?>(
      (model) => model.totalElevationGain,
    );

    bool loadingPathData = context.select<PlannedTourModel, bool>(
      (model) => model.loadingPathData,
    );

    // List<MatchedRule>? matchedRules =
    //     context.select<PlannedTourModel, List<MatchedRule>>(
    //   (model) => model.matchedRules,
    // );

    bool addMarkers = context.select<PlannedTourModel, bool>(
      (model) => model.addMarkers,
    );

    void handleUndo() async {
      bool isEmpty = await PlannedTourCommand().undo();
      if (isEmpty) {
        await MapCommand().clearMap();
        return;
      }

      var route = PlannedTourCommand().getRoute();
      List<Marker>? markers = PlannedTourCommand().getMarkers();

      await MapCommand().clearMap();
      if (markers != null) {
        await MapCommand().updateMarkers(markers);
      }

      if (route != null) {
        route.add(PlannedTourCommand().getLastMarker().point);

        await MapCommand().updatePolyline(route, "planned", null);
      }
    }

    void generateRoute() async {
      List<MatchedRule> matchedRules = PlannedTourCommand().getMatchedRules();
      if (matchedRules.isNotEmpty) {
        await MapCommand().clearMatchedRules(matchedRules);
      }
      await PlannedTourCommand().generateRoute();

      // get updated list of matched rules
      matchedRules = PlannedTourCommand().getMatchedRules();
      if (matchedRules != null && matchedRules.isNotEmpty) {
        await MapCommand().addWarningMarkers(matchedRules, context);
      }
    }

    return Flexible(
      flex: 12,
      fit: FlexFit.tight,
      child: Column(
        children: [
          SizedBox(
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColorLight),
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      MapCommand().hideTourPlanningContainer("planning");
                    },
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).primaryColorLight,
          ),
          Flexible(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Text(
                  //   "Planning tour",
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .titleSmall!
                  //       .copyWith(color: const Color.fromARGB(141, 0, 0, 0)),
                  //   textAlign: TextAlign.center,
                  // ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: ElevatedButton(
                        onPressed: () async {
                          await pickDate();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            )),
                        child: Text(
                            '${plannedTourTime?.day}/${plannedTourTime?.month}/${plannedTourTime?.year}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 18))),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: ElevatedButton(
                        onPressed: () async {
                          await pickTime();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            )),
                        child: Text(
                            '${plannedTourTime?.hour.toString().padLeft(2, '0')}:${plannedTourTime?.minute.toString().padLeft(2, '0')}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 18))),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Color.fromARGB(26, 0, 0, 0),
            thickness: 1,
            height: 0,
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Switch(
                        value: addMarkers, // add markers on long press
                        activeColor: Theme.of(context).secondaryHeaderColor,
                        onChanged: (value) {
                          PlannedTourCommand().setAddMarkers(value);
                        },
                      ),
                      Text(addMarkers
                          ? "Markers"
                          : "Disabled"), // add markers on long press
                    ],
                  ),
                ),
                const VerticalDivider(
                  width: 20,
                  color: Color.fromARGB(26, 0, 0, 0),
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Switch(
                        value: !drawStraightLine,
                        activeColor: Theme.of(context).secondaryHeaderColor,
                        onChanged: (value) {
                          // when switch's value is true we call Mapbox directions API for route generation
                          // when switch's value is false we just draw a line between points (useful for offline use and when there is no mapped route between points)
                          checkConnectivity().then((_) {
                            // if there is no internet connection we can't generate route, because we need to call Mapbox directions API
                            internetConnection != null &&
                                    internetConnection == true
                                ? PlannedTourCommand()
                                    .setDrawStraightLine(!value)
                                : null;
                          });
                        },
                      ),
                      Text(drawStraightLine
                          ? "Straight line"
                          : "Generate route"),
                    ],
                  ),
                ),
                const VerticalDivider(
                  width: 20,
                  color: Color.fromARGB(26, 0, 0, 0),
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          // remove last added point
                          handleUndo();
                        },
                        icon: const Icon(Icons.undo),
                      ),
                      const Text("Undo"),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(26, 0, 0, 0),
            thickness: 1,
            height: 0,
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        distance != null
                            ? (distance / 1000).toStringAsFixed(2)
                            : "0.00",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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
                  indent: 10,
                  endIndent: 10,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total duration (h)',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        printDuration(
                            Duration(
                                seconds:
                                    duration != null ? duration.toInt() : 0),
                            false),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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
                  indent: 10,
                  endIndent: 10,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Elevation gain (m)',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        totalElevationGain != null
                            ? totalElevationGain.toStringAsFixed(1)
                            : "0",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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
          const Divider(
            color: Color.fromARGB(26, 0, 0, 0),
            thickness: 1,
            height: 0,
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // text on click
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          // cancel router planning
                          PlannedTourCommand().stopTourPlanning();
                          MapCommand().stopTourPlanning();
                        },
                        child: const Text(
                          "Cancel",
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 20,
                    color: Color.fromARGB(26, 0, 0, 0),
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Center(
                      child: loadingPathData
                          ? const CircularProgressIndicator()
                          : GestureDetector(
                              onTap: () {
                                // save route
                                checkConnectivity().then((_) {
                                  // we can only generate route if we have internet connection, because we need to download elevation data from arcGIS
                                  internetConnection != null &&
                                          internetConnection == true
                                      ? generateRoute()
                                      : null;
                                });
                              },
                              child: Text("Calculate"),
                            ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 20,
                    color: Color.fromARGB(26, 0, 0, 0),
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          // save route
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const SavePlannedTour()),
                          );
                        },
                        child: const Text(
                          "Save route",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
