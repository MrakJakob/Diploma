import 'package:flutter/material.dart';

class AppModel extends ChangeNotifier {
  // holds the state of the app
  String _currentUser = "";
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();

  String get currentUser => _currentUser;
  bool get isLogin => _isLogin;
  GlobalKey<FormState> get formKey => _formKey;

  set currentUser(String currentUser) {
    _currentUser = currentUser;
    notifyListeners();
  }

  set isLogin(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }
}
