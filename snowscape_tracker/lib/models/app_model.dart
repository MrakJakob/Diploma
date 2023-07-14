import 'package:flutter/material.dart';
import 'package:snowscape_tracker/views/explore_page.dart';
import 'package:snowscape_tracker/views/map_page.dart';
import 'package:snowscape_tracker/views/profile_page.dart';

class AppModel extends ChangeNotifier {
  // holds the state of the app
  String _currentUser = "";
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _pages = [const MapPage(), ExplorePage(), const ProfilePage()];
  Widget _selectedPage = const MapPage();
  int _selectedPageIndex = 0;

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

  set setSelectedPage(int pageIndex) {
    _selectedPageIndex = pageIndex;
    _selectedPage = _pages[pageIndex];
    notifyListeners();
  }

  get selectedPage => _selectedPage;

  get selectedPageIndex => _selectedPageIndex;
}
