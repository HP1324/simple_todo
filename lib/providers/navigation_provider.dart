import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier{
  var selectedDestination = 0;
  void onDestinationSelected(int selected) {
    selectedDestination = selected;
    notifyListeners();
  }

}