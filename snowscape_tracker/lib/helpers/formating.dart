import 'package:flutter/material.dart';

String printDuration(
  Duration duration,
  bool? abbreviated,
) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  if (abbreviated == null || !abbreviated) {
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  if (duration.inHours > 0) {
    String twoDigitHours = twoDigits(duration.inHours);
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds h";
  } else if (duration.inMinutes > 0) {
    return "$twoDigitMinutes:$twoDigitSeconds min";
  } else {
    return "00:$twoDigitSeconds s";
  }
}

String formatDuration(Duration duration) {
  debugPrint("formatDuration: $duration");
  if (duration.inHours > 0) {
    return "${duration.inHours}h ${duration.inMinutes.remainder(60)}min";
  } else if (duration.inMinutes > 0) {
    return "${duration.inMinutes.remainder(60)} min ${duration.inSeconds.remainder(60)} s";
  } else {
    return "${duration.inSeconds.remainder(60)}s";
  }
}
