import 'package:flutter/material.dart';

class SideNavProvider extends ChangeNotifier {
  int selectedIndex = 0;

  void selectTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
