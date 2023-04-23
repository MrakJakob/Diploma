import 'base_command.dart';

class SignupCommand extends BaseCommand {
  Future<bool> execute(String email, String password) async {
    bool signupSuccess = await userService.signup(email, password);

    return signupSuccess;
  }

  void switchToLogin() {
    appModel.isLogin = true;
  }
}