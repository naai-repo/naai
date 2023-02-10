import 'package:flutter/material.dart';

class BottomNavigationProvider with ChangeNotifier {
  int _currentScreenIndex = 0;

  int get currentScreenIndex => _currentScreenIndex;

  void setCurrentScreenIndex(int value) {
    _currentScreenIndex = value;
    notifyListeners();
  }
}
