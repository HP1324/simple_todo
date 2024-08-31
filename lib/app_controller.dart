import 'package:flutter/material.dart';
import 'package:planner/models/task.dart';

class AppStateProvider extends StatefulWidget {
  const AppStateProvider({super.key, required this.child});
  final Widget child;
  @override
  State<AppStateProvider> createState() => _AppStateProviderState();
}

class _AppStateProviderState extends State<AppStateProvider> with SingleTickerProviderStateMixin{
  List<Task> tasks = Task.getTasksList();
  List<Task> tasksDone = Task.getTasksDoneList();
  ThemeData themeData = ThemeData.light();
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }
  void toggleTheme() {
    setState(() {
      if (themeData == ThemeData.light()) {
        themeData = ThemeData.dark();
      } else {
        themeData = ThemeData.light();
      }
    });
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  ///Returns true if [task] is successfully added.
  bool addTask(Task task) {
    if (task.title.isNotEmpty) {
      setState(() {
        tasks.add(task);
      });
      return true;
    }
    return false;
  }

  void deleteFromTasksList(Task task) {
    setState(() {
      if (tasks.contains(task)) {
        tasks.remove(task);
      }
    });
  }

  editTask(Task task, {required String newTitle}) {
    setState(() {
      task.title = newTitle;
    });
  }

  void markTaskAsDone(Task task) {
    setState(() {
      if (!task.isDone) {
        tasks.remove(task);
        tasksDone.add(task);
        task.isDone = true;
      }
    });
  }

  void deleteFromTasksDoneList(Task task) {
    setState(() {
      tasksDone.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppController(
      tasks: tasks,
      tasksDone: tasksDone,
      themeData: themeData,
      stateWidget: this,
      tabController: tabController,
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
      required this.tabController,
      required this.stateWidget});
  final List<Task> tasks;
  final List<Task> tasksDone;
  final ThemeData themeData;
  final TabController tabController;
  final _AppStateProviderState stateWidget;
  @override
  bool updateShouldNotify(AppController oldWidget) {
    return true;
  }

  static _AppStateProviderState of(BuildContext context) {
    var stateManager = context
        .dependOnInheritedWidgetOfExactType<AppController>()!
        .stateWidget;

    return stateManager;
  }
}
