import 'package:flutter/material.dart';
import 'package:planner/models/task.dart';
import 'package:planner/services/category_service.dart';
import 'package:planner/services/task_service.dart';

class TaskProvider extends ChangeNotifier{
  TaskProvider(){ _refreshTasks();}
  List<Map<String, dynamic>> tasks = [];


  Future<void> _refreshTasks() async {
    debugPrint(
        '********************inside refreshData()****************************');
      tasks = await TaskService.getTasks();
    notifyListeners();
      debugPrint(tasks.toString());
    debugPrint(
        '********************end of refreshData()****************************');
  }

  bool isNewTaskAdded = false;

  Future<bool> addTask(Task task, {int? categoryId}) async {
    task.categoryId = categoryId ?? 1;
    task.title = task.title.trim();
    if (task.title.isNotEmpty) {
      await TaskService.addTask(task);
      _refreshTasks();
      isNewTaskAdded = true;
      return true;
    }
    return false;
  }
  Future<bool> editTask({
    required Task task,
  }) async {
    var trimmed = task.title.trim();

    ///For some reason [trimmed.isEmpty] and [trimmed.isNotEmpty] were not working as expected and they were allowing to save an empty task, so I had to do this:
    if (trimmed.isNotEmpty) {
      await TaskService.editTask(task);
      _refreshTasks();
      return true;
    }
    return false;
  }

  Future<void> deleteTask({required Task taskToDelete}) async {
    await TaskService.deleteTask(id: taskToDelete.id!);
    _refreshTasks();
  }


  Future<void> toggleDone(Task task) async {
    await TaskService.toggleDone(task);
    _refreshTasks();
  }
  void toggleChecked(Task task, bool? newValue) {
    task.isDone = newValue!;
  }
}