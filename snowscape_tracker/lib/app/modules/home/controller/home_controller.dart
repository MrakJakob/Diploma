// import 'package:provider/provider.dart';
import "package:flutter/material.dart";

class HomeState {
  int counter = 0;
}

class HomeController extends ChangeNotifier {
  HomeState state = HomeState();

  incrementCounter() {
    state.counter++;
    notifyListeners();
  }
}
