import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:planner/models/task.dart';
import 'package:planner/services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final _player = AudioPlayer();
  TaskProvider() {
    _refreshTasks();
  }
  List<Map<String, dynamic>> allTasks = [];
  Future<void> _refreshTasks() async {
    debugPrint('************inside refreshTasks()************');
    ///Filter tasks based on the value of [filterFlag] variable
    allTasks =  await TaskService.getTasks().then((tasks) {
      if (filterFlag == 0)
        return tasks;
      else if (filterFlag == 1)
        return tasks.where((task) => Task.fromJson(task).isDone).toList();
      else
        return tasks.where((task) => !(Task.fromJson(task).isDone)).toList();
    });
    notifyListeners();
    debugPrint(allTasks.toString());
    debugPrint('************end of refreshTasks()************');
  }

  bool isNewTaskAdded = false;

  Future<bool> addTask(Task task) async {
    task.title = task.title.trim();

    if (task.title.isNotEmpty) {
      await TaskService.addTask(task);
      _refreshTasks();
      debugPrint('Task added to database -> -> ${task.toJson()}');
      isNewTaskAdded = true;
      return true;
    }
    return false;
  }

  Future<void> editTask(
      {required Task taskToEdit, String? title, int? categoryId}) async {
    if (title != null) {
      taskToEdit.title = title;
    }
    if (categoryId != null) {
      taskToEdit.categoryId = categoryId;
    }
    await TaskService.editTask(newTask: taskToEdit.toJson());
    _refreshTasks();
  }

  Future<void> deleteTask({required Task taskToDelete}) async {
    await TaskService.deleteTask(id: taskToDelete.id!);
    _refreshTasks();
  }

  Future<void> toggleDone(Task task, bool newValue) async {
    ///This line is responsible for managing checkbox's state : checked or unchecked
    task.isDone = newValue;
    debugPrint('is done in toggledone ${task.isDone}');
    // await _playSound(task.isDone);
    if (filterFlag != 0) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    await TaskService.toggleDone(task.id as int, task.isDone);

    _refreshTasks();
  }

  Future<void> _playSound(bool isDone) async {
    try {
      if (isDone) {
        await _player.play(AssetSource('audio/mark_don2.wav'));
      }
    } catch (e) {
      debugPrint('Error playing sound ${e.toString()}');
    }
  }

  //This part handles all the filter related logic

  Map<String, bool> chipSelection = {
    'Done': false,
    'Undone': false,
  };

  ///This [filterFlag] variable is managing three states of filtering
  /// 0 = All tasks
  /// 1 = Tasks done
  /// 2 = Tasks not done
  int filterFlag = 0;

  void toggleSelected(String label, bool value) {
    ///This line makes sure that only one of the chips is getting selected. all the other selected chips will
    ///be set to false with the use of [updateAll] method
    chipSelection.updateAll((k, v) => k == label ? value : false);
    _setFilterDone(label);
    notifyListeners();
  }

  ///This function manages the value of [filterFlag] variable based on the value of [label]
  void _setFilterDone(String label) {
    ///Checking if no chip is currently selected in order to show all tasks again by setting [filterDone]
    /// to [zero]. For this I have used [every] method from [abstract mixin class Iterable] which checks whether or not a certain object is set
    /// to a certain value. if all are false then [filterDone] is zero which will show all tasks again.
    bool allFalse = chipSelection.values.every((value) => value == false);
    if (allFalse)
      filterFlag = 0;
    else {
      filterFlag = label == 'Done' ? 1 : 2;
    }
    debugPrint('filter: $filterFlag');
    _refreshTasks();
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }
}
