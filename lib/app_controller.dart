import 'package:flutter/material.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/models/task.dart';
import 'package:planner/services/database_service.dart';

class Provider extends StatefulWidget {
  const Provider({super.key, required this.child});
  final Widget child;
  @override
  State<Provider> createState() => _ProviderState();
}

class _ProviderState extends State<Provider> {
  ///Database control is over here
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> tasksDone = [];
  void _refreshData() async {
    final data = await DatabaseService.getTasks();
    final dataDone = await DatabaseService.getTasksDone();
    setState(() {
      tasks = data;
      tasksDone = dataDone;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  ///Theme state
  ThemeData themeData = AppTheme.lightMode;

  ///The state of app theme is managed through this function
  void toggleTheme() {
    setState(() => themeData = themeData == AppTheme.lightMode
        ? themeData = AppTheme.darkMode
        : themeData = AppTheme.lightMode);
  }

  ///Checkbox state management

  void toggleChecked(Task task, bool? newValue) {
    ///All this headache is just for showing the checkbox being checked in the UI, there is no purpose of writing all this except this.
    setState(() {
      List<Map<String, dynamic>> updatedTasks = List.from(tasks);
      int index = tasks.indexWhere((t)=>Task.fromJson(t).id == task.id);
      if(index != -1){
        updatedTasks[index] = {
          'id': updatedTasks[index]['id'], // Preserve the id
          'title': updatedTasks[index]['title'], // Preserve the title
          'isDone': newValue! ? 1 : 0, // Update isDone
        };
      }
      tasks = updatedTasks;
    });
  }

  ///This part is managing the [NavigationBar]'s selected destination state

  var selectedDestination = 0;
  void onDestinationSelected(int selected) {
    setState(() => selectedDestination = selected);
  }

  ///The rest of the functions are managing the state of [TasksList] and [TasksDone] list.
  ///
  ///Returns true if [task] is successfully added.
  Future<bool> addTask(Task task) async {
    task.title = task.title.trim();
    if (task.title.isNotEmpty) {
      await DatabaseService.addTask(task.title, task.isDone);
      _refreshData();
      return true;
    }
    return false;
  }

  ///Delete  [thisTask] [fromThislist]
  Future<void> deleteFromList(
      {required Task thisTask, required String fromThisList}) async {
    await DatabaseService.deleteTask(
        id: thisTask.id!, tableName: fromThisList);
    _refreshData();
  }

  ///Returns true if [task] is successfully edited.
  Future<bool> editTask(
      {required Task task, required String newTitle}) async {
    var trimmed = task.title.trim();
    if (trimmed.isNotEmpty) {
      await DatabaseService.editTask(task, newTitle, false);
      _refreshData();
      return true;
    }
    return false;
  }

  Future<void> toggleDone(Task task) async {
    if (!task.isDone) {
      await DatabaseService.toggleDone(task, 'tasks');
    } else if (task.isDone) {
      await DatabaseService.toggleDone(task, 'tasksDone');
    }
    _refreshData();

    ///Using only if here was a silly mistake, because task.isDone is set to true in the first if, so the second if will also run even if we don't want to do that. To solve that I have to use else if, instead of just if, to ensure only one of the blocks run
  }

  @override
  Widget build(BuildContext context) {
    return AppController(
      tasks: tasks,
      tasksDone: tasksDone,
      themeData: themeData,
      selectedNavigation: selectedDestination,
      stateWidget: this,
      child: widget.child,
    );
  }
}

class AppController extends InheritedWidget {
  const AppController(
      {super.key,
      required super.child,
      required this.tasks,
      required this.tasksDone,
      required this.themeData,
      required this.selectedNavigation,
      required this.stateWidget});

  final List<Map<String, dynamic>> tasks;
  final List<Map<String, dynamic>> tasksDone;
  final ThemeData themeData;
  final int selectedNavigation;
  final _ProviderState stateWidget;
  @override
  bool updateShouldNotify(AppController oldWidget) {
    return true;
  }

  static _ProviderState of(BuildContext context) {
    var stateManager = context
        .dependOnInheritedWidgetOfExactType<AppController>()!
        .stateWidget;
    return stateManager;
  }
}
