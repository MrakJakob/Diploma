import 'base_command.dart';

class SignupCommand extends BaseCommand {
  Future<bool> execute(
      String email, String password, String displayName) async {
    bool signupSuccess = await userService.signup(email, password, displayName);

    return signupSuccess;
  }

  void switchToLogin() {
    appModel.isLogin = true;
  }
}
