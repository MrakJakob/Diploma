import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:snowscape_tracker/commands/map_command.dart';
import 'package:snowscape_tracker/commands/planned_tour_command.dart';

class SavePlannedTour extends StatefulWidget {
  const SavePlannedTour({super.key});

  @override
  _SavePlannedTourState createState() => _SavePlannedTourState();
}

class _SavePlannedTourState extends State<SavePlannedTour> {
  @override
  Widget build(BuildContext context) {
    Future<void> savePlannedTour() async {
      int sucess = await PlannedTourCommand().savePlannedTour();

      if (sucess > 0) {
        PlannedTourCommand().stopTourPlanning();
        await MapCommand().clearMap();
        MapCommand().hideTourPlanningContainer();
        return;
      }
      return;
    }

    return LoaderOverlay(
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: SafeArea(
              child: Center(
                child: Text(
                  'Save Planned Tour',
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
                            controller: PlannedTourCommand()
                                .plannedTourNameController(),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                    width: 2.0,
                                    color: Theme.of(context).primaryColor)),
                            child: Text(
                              'Cancel',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
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
                              context.loaderOverlay.show();
                              savePlannedTour().then((_) {
                                context.loaderOverlay.hide();
                                Navigator.of(context).pop();
                              });
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
          )),
    );
  }
}
