import 'package:snowscape_tracker/commands/base_command.dart';
import 'package:snowscape_tracker/data/recorded_activity.dart';

class ExploreCommand extends BaseCommand {
  Stream<List<RecordedActivity>>? readPublicRecordedSessions() {
    return recordedActivityService.readPublicRecordedSessions();
  }
}
