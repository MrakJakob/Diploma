import 'package:snowscape_tracker/commands/base_command.dart';

class AppCommand extends BaseCommand {
  void switchMainPage(int pageIndex) {
    appModel.setSelectedPage = pageIndex;
  }
}
