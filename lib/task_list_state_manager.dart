import 'package:flutter/material.dart';
import 'package:planner/models/task.dart';

class MainState extends StatefulWidget {
  const MainState({super.key, required this.child});
  final Widget child;
  @override
  State<MainState> createState() => _MainStateState();
}

class _MainStateState extends State<MainState> {
  List<Task> tasks = Task.getTasksList();
  List<Task> tasksDone = Task.getTasksDoneList();

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
    return TaskListStateManager(
        child: widget.child,
        tasks: tasks,
        tasksDone: tasksDone,
        stateWidget: this);
  }
}

class TaskListStateManager extends InheritedWidget {
  const TaskListStateManager(
      {super.key,
      required super.child,
      required this.tasks,
      required this.tasksDone,
      required this.stateWidget});

  final List<Task> tasks;
  final List<Task> tasksDone;
  final _MainStateState stateWidget;
  @override
  bool updateShouldNotify(TaskListStateManager oldWidget) {
    return true;
  }

  static _MainStateState of(BuildContext context) {
    var stateManager = context
        .dependOnInheritedWidgetOfExactType<TaskListStateManager>()!
        .stateWidget;

    return stateManager;
  }
}
