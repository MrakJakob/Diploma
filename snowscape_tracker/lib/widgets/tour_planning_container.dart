import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:snowscape_tracker/commands/planned_tour_command.dart';
import 'package:snowscape_tracker/data/rules/matched_rule.dart';
import 'package:snowscape_tracker/helpers/formating.dart';
import 'package:snowscape_tracker/models/planned_tour_model.dart';

class TourPlanningContainer extends StatelessWidget {
  const TourPlanningContainer({super.key});

  @override
  Widget build(BuildContext context) {
    double? distance = context.select<PlannedTourModel, double?>(
      (model) => model.distance,
    );

    double? duration = context.select<PlannedTourModel, double?>(
      (model) => model.duration,
    );

    bool drawStraightLine = context.select<PlannedTourModel, bool>(
      (model) => model.drawStraightLine,
    );

    int? totalElevationGain = context.select<PlannedTourModel, int?>(
      (model) => model.totalElevationGain,
    );

    bool loadingPathData = context.select<PlannedTourModel, bool>(
      (model) => model.loadingPathData,
    );

    List<MatchedRule> matchedRules =
        context.select<PlannedTourModel, List<MatchedRule>>(
      (model) => model.matchedRules,
    );

    void handleUndo() async {
      bool isEmpty = await PlannedTourCommand().undo();
      if (isEmpty) {
        await MapCommand().clearMap();
        return;
      }
      // MapCommand().removeLastMarker();
      var route = PlannedTourCommand().getRoute();
      route.add(PlannedTourCommand().getLastMarker().point);
      await MapCommand().clearMap();
      await MapCommand().updatePolyline(route, "planned");
      await MapCommand().updateMarkers(PlannedTourCommand().getMarkers());
    }

    void generateRoute() async {
      await PlannedTourCommand().generateRoute();

      if (matchedRules.isNotEmpty) {
        await MapCommand().addWarningMarkers(matchedRules, context);
      }
    }

    return Flexible(
      flex: 8,
      fit: FlexFit.tight,
      child: Column(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Planning tour",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: const Color.fromARGB(141, 0, 0, 0)),
                textAlign: TextAlign.center,
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
                        value: !drawStraightLine,
                        onChanged: (value) {
                          // when switch's value is true we call Mapbox directions API for route generation
                          // when switch's value is false we just draw a line between points (useful for offline use and when there is no mapped route between points)
                          PlannedTourCommand().setDrawStraightLine(!value);
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
                        printDuration(Duration(
                            seconds: duration != null ? duration.toInt() : 0)),
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
                        'Total elevation (m)',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        totalElevationGain != null
                            ? totalElevationGain.toString()
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
                          MapCommand().clearMap();
                          MapCommand().hideTourPlanningContainer();
                        },
                        child: Text("Cancel",
                            style: Theme.of(context).textTheme.titleSmall),
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
                                generateRoute();
                              },
                              child: Text("Generate route",
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
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
