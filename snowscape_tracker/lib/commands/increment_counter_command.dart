import 'base_command.dart';

class IncrementCounterCommand extends BaseCommand {
  void execute() {
    homeModel.counter++;
    return;
  }
}
