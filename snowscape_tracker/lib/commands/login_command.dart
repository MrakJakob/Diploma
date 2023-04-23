import 'base_command.dart';

class LoginCommand extends BaseCommand {
  Future<bool> execute(String email, String password) async {
    bool loginSuccess = await userService.login(email, password);

    return loginSuccess;
  }

  void switchToSignup() {
    appModel.isLogin = false;
  }
}
