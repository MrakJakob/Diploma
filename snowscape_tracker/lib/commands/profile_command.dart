import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:snowscape_tracker/data/recorded_activity.dart';

class ProfileCommand extends BaseCommand {
  void setPageIndex(int index) {
    if (index < 0 || index > 1) return;

    profileModel.setIndex(index);
  }

  Stream<List<RecordedActivity>>? readRecordedSessions() {
    return recordedActivityService.readRecordedSessions();
  }
}
