import 'base_command.dart';

class LogoutCommand extends BaseCommand {
  Future<bool> execute() async {
    bool loginSuccess = await userService.logout();

    return loginSuccess;
  }
}
