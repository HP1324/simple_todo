import 'package:flutter/material.dart';
import 'package:planner/globals.dart';

class FilterProvider extends ChangeNotifier{
  Map<String,bool> chipSelection = {
    'Done' : false,
    'Undone' : false,
  };

  int filterDone = 0;
  void toggleSelected(String label, bool value){
    chipSelection.updateAll((k,v)=>k == label ? value : false );
    setFilterDone(label);
    notifyListeners();
  }

  setFilterDone(String label){
      bool allFalse = chipSelection.values.every((value) => value == false);
      if(allFalse) filterDone = 0;
      else{
        filterDone = label == 'Done' ? 1 : label == 'Undone' ? 2 : 0;
      }
  }
}