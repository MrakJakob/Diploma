import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/models/app_model.dart';
import 'package:snowscape_tracker/views/login_page.dart';
import 'package:snowscape_tracker/views/signup_page.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isLogin = context.select<AppModel, bool>((model) => model.isLogin);
    debugPrint("isLogin: $isLogin");
    return isLogin ? LoginPage() : SignupPage();
  }
}
