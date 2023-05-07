import 'package:snowscape_tracker/utils/user_preferences.dart';

import 'base_command.dart';

class LogoutCommand extends BaseCommand {
  Future<bool> execute() async {
    bool loginSuccess = await userService.logout();
    if (loginSuccess) {
      // clear shared preferences
      UserPreferences.clearSharedPrefs();
    }

    return loginSuccess;
  }
}
