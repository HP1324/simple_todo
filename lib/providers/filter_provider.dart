import 'package:flutter/material.dart';
import 'package:planner/globals.dart';

class FilterProvider extends ChangeNotifier{
  Map<String,bool> chipSelection = {
    'Done' : false,
    'Undone' : false,
  };

  ///This [filterDone] variable is managing three states of filtering
  /// 0 = All tasks
  /// 1 = Tasks done
  /// 2 = Tasks not done
  int filterDone = 0;

  void toggleSelected(String label, bool value){
    ///This line makes sure that only one of the chips is getting selected. all the other selected chips will
    ///be set to false with the use of [updateAll] method
    chipSelection.updateAll((k,v)=>k == label ? value : false );
    setFilterDone(label);
    notifyListeners();
  }

  ///This function manages the value of [filterDone] variable based on the value of label
  setFilterDone(String label){
      ///Checking if no chip is currently selected in order to show all tasks again by setting [filterDone]
      /// to [zero]. For this I have used every function which checks whether or not a certain object is set
      /// to a certain value. if all are false then [filterDone] is zero which will show all tasks again.
      bool allFalse = chipSelection.values.every((value) => value == false);
      if(allFalse) filterDone = 0;
      else{
        filterDone = label == 'Done' ? 1 : label == 'Undone' ? 2 : 0;
      }
  }
}