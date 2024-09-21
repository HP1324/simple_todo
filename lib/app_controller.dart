import 'package:flutter/material.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/models/task.dart';

class AppStateProvider extends StatefulWidget {
  const AppStateProvider({super.key, required this.child});
  final Widget child;
  @override
  State<AppStateProvider> createState() => _AppStateProviderState();
}

class _AppStateProviderState extends State<AppStateProvider>
    with SingleTickerProviderStateMixin {
  ///Theme state
  ThemeData themeData = AppTheme.lightMode;

  ///tab state
  late TabController tabController;

  ///tasklist and tasksdonelist state
  List<Task> tasks = Task.getTasksList();
  List<Task> tasksDone = Task.getTasksDoneList();

  void setChecked(Task task, bool checked) {
    setState(() {
      task.isDone = checked;
    });
  }

  ///The state of app theme is managed through this function
  void toggleTheme() {
    setState(() {
      if (themeData == AppTheme.lightMode) {
        themeData = AppTheme.darkMode;
      } else {
        themeData = AppTheme.lightMode;
      }
    });
  }

  ///This part is managing whether the FAB appears or not on the screen through the tab bar's state.
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  ///The rest of the functions are managing the state of [TasksList] and [TasksDone] list.
  ///
  ///Returns true if [task] is successfully added.
  bool addTask(Task task) {
    task.title = task.title.trim();
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
  ///Returns true if [task] is successfully edited.
  bool editTask(Task task, {required String newTitle}) {
    var trimmed = newTitle.trim();
    if (trimmed.isNotEmpty) {
      setState(() {
        task.title = trimmed;
      });
      return true;
    }
    return false;
  }

  void markTaskAsDone(Task task) {
    setState(() {
      tasks.remove(task);
      tasksDone.add(task);
    });
  }

  void markTaskAsUnDone(Task task) {
    setState(() {
      if (task.isDone) {
        tasksDone.remove(task);
        tasks.add(task);
        task.isDone = false;
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
