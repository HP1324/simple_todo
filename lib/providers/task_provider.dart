import 'package:flutter/material.dart';
import 'package:planner/models/task.dart';
import 'package:planner/services/task_service.dart';

class TaskProvider extends ChangeNotifier{
  TaskProvider(){ _refreshTasks();}
  List<Map<String, dynamic>> allTasks = [];
  List<Map<String, dynamic>> tasksDone = [];
  List<Map<String, dynamic>> tasksNotDone = [];


  Future<void> _refreshTasks() async {
    debugPrint( '************inside refreshTasks()************');
      allTasks = await TaskService.getTasks();
    tasksDone = allTasks.where((task) => Task.fromJson(task).isDone).toList();
    tasksNotDone = allTasks.where((task) => !(Task.fromJson(task).isDone)).toList();
    debugPrint('These tasks are done $tasksDone');
      debugPrint('These tasks are not done $tasksNotDone');
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
  Future<void> editTask({required Task taskToEdit,String? title, int? categoryId}) async {
    if(title != null){
      taskToEdit.title = title;
    }
    if(categoryId != null){
      taskToEdit.categoryId = categoryId;
    }
    await TaskService.editTask(taskToEdit);
    _refreshTasks();
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