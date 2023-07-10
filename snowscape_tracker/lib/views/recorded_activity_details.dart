import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:snowscape_tracker/data/recorded_activity.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:snowscape_tracker/helpers/formating.dart';

class RecordedActivityDetails extends StatefulWidget {
  final RecordedActivity recordedActivity;

  const RecordedActivityDetails(
    this.recordedActivity, {
    Key? key,
  }) : super(key: key);

  @override
  State<RecordedActivityDetails> createState() =>
      _RecordedActivityDetailsState();
}

class _RecordedActivityDetailsState extends State<RecordedActivityDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: Center(
              child: Text(
                widget.recordedActivity.tourName,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          child: Flexible(
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(
                            TablerIcons.user_circle,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.recordedActivity.userName.length > 0
                                ? widget.recordedActivity.userName
                                : "Anonymous",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              DateFormat("dd.MM.yyyy")
                                  .format(widget.recordedActivity.startTime),
                              style: Theme.of(context).textTheme.bodyLarge!),
                          const SizedBox(width: 5),
                          const Icon(
                            TablerIcons.calendar,
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Image(
                      image: AssetImage("assets/mountain.png"),
                      width: 140,
                      height: 140,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Icon(
                            TablerIcons.shoe,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${widget.recordedActivity.distance.toStringAsFixed(2)} km",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(
                            TablerIcons.clock,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            formatDuration(Duration(
                                seconds: widget.recordedActivity.duration)),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(
                            TablerIcons.mountain,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${widget.recordedActivity.elevationGain.toStringAsFixed(0)} m",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tour difficulty",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 10),
                      RatingBarIndicator(
                          itemBuilder: (context, index) => const Icon(
                                TablerIcons.star,
                                color: Colors.amber,
                              ),
                          rating: widget.recordedActivity.difficulty.toDouble(),
                          itemCount: 5,
                          itemSize: 30,
                          direction: Axis.horizontal),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tour description",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.recordedActivity.tourDescription,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ),
        ));
  }
}
