import 'package:flutter/material.dart';
import 'package:planner/models/task.dart';
import 'package:planner/services/database_service.dart';
import 'package:planner/services/task_service.dart';

class MyProvider extends StatefulWidget {
  const MyProvider({super.key, required this.child});
  final Widget child;
  @override
  State<MyProvider> createState() => StateProvider();
}

class StateProvider extends State<MyProvider> {
  bool isNewTaskAdded = false;

  ///Database control is over here
  List<Map<String, dynamic>> tasks = [];
  void _refreshData() async {
    debugPrint(
        '********************inside refreshData()****************************');
    final data = await TaskService.getTasks();
    setState(() {
      tasks = data;
      debugPrint(tasks.toString());
    });
    debugPrint(
        '********************end of refreshData()****************************');
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  ///[TaskList] scroll controller
  ScrollController scrollController = ScrollController();


  ///Checkbox state management

  void toggleChecked(Task task, bool? newValue) {
    setState(() => task.isDone = newValue!);
  }

  ///This part is managing the [NavigationBar]'s selected destination state

  var selectedDestination = 0;
  void onDestinationSelected(int selected) {
    setState(() => selectedDestination = selected);
  }

  ///Task title and description controller
  var titleController = TextEditingController();
  List<String> categories = ['Home', 'Work', 'Personal', 'Family'];


  ///Returns true if [task] is successfully added.
  Future<bool> addTask(Task task) async {
    task.title = task.title.trim();
    if (task.title.isNotEmpty) {
      await TaskService.addTask(task);
      _refreshData();
      isNewTaskAdded = true;
      return true;
    }
    return false;
  }

  ///Delete task from database
  Future<void> deleteTask({required Task taskToDelete}) async {
    await TaskService.deleteTask(id: taskToDelete.id!);
    _refreshData();
  }

  ///Returns true if [task] is successfully edited.
  Future<bool> editTask({
    required Task task,
  }) async {
    var trimmed = task.title.trim();

    ///For some reason [trimmed.isEmpty] and [trimmed.isNotEmpty] were not working as expected and they were allowing to save an empty task, so I had to do this:
    if (trimmed.isNotEmpty) {
      await TaskService.editTask(task);
      _refreshData();
      return true;
    }
    return false;
  }

  Future<void> toggleDone(Task task) async {
    await TaskService.toggleDone(task);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return AppController(
      tasks: tasks,
      scrollController: scrollController,
      selectedDestination: selectedDestination,
      titleController: titleController,
      categories: categories,
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
      required this.scrollController,
      required this.selectedDestination,
      required this.titleController,
      required this.categories,
      required this.stateWidget});

  final List<Map<String, dynamic>> tasks;
  final ScrollController scrollController;
  final int selectedDestination;
  final TextEditingController titleController;
  final List<String> categories;
  final StateProvider stateWidget;
  @override
  @override
  bool updateShouldNotify(AppController oldWidget) {
    return tasks != oldWidget.tasks ||
        selectedDestination != oldWidget.selectedDestination ||
        titleController != oldWidget.titleController ||
        categories != oldWidget.categories ||
        stateWidget != oldWidget.stateWidget;
  }


  static StateProvider of(BuildContext context) {
    var stateManager = context
        .dependOnInheritedWidgetOfExactType<AppController>()!
        .stateWidget;
    return stateManager;
  }
}
