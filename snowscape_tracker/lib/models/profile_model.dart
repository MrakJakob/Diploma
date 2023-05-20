import "package:flutter/material.dart";

class ProfileModel extends ChangeNotifier {
  int _selectedIndex = 0;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;
}
