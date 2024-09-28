import 'package:flutter/material.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/models/task.dart';
import 'package:planner/services/database_service.dart';

class Provider extends StatefulWidget {
  const Provider({super.key, required this.child});
  final Widget child;
  @override
  State<Provider> createState() => StateProvider();
}

class StateProvider extends State<Provider> {
  bool isNewTaskAdded = false;

  ///Database control is over here
  List<Map<String, dynamic>> tasks = [];
  void _refreshData() async {
    debugPrint(
        '********************inside refreshData()****************************');
    final data = await DatabaseService.getTasks();
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

  ///Theme state
  ThemeData themeData = AppTheme.lightMode;
  // Icon icon = Icon(Icons.dark_mode);
  WidgetStateProperty<Icon> icon =
      WidgetStatePropertyAll(Icon(Icons.dark_mode));
  bool isDark = false;

  ///The state of app theme is managed through this function
  void toggleTheme(bool newValue) {
    setState(() {
      isDark = newValue;
      if (themeData == AppTheme.lightMode) {
        themeData = AppTheme.darkMode;
        icon = WidgetStatePropertyAll(Icon(Icons.light_mode));
      } else {
        themeData = AppTheme.lightMode;
        icon = WidgetStatePropertyAll(Icon(Icons.dark_mode));
      }
    });
  }

  ///Checkbox state management

  void toggleChecked(Task task, bool? newValue) {
    debugPrint(
        '------------------------Inside provider.toggleChecked()---------------------------');
    debugPrint('newValue currently is: $newValue');
    setState(() => task.isDone = newValue!);
    debugPrint(
        '------------------------End of provider.toggleChecked()---------------------------');
  }

  ///This part is managing the [NavigationBar]'s selected destination state

  var selectedDestination = 0;
  void onDestinationSelected(int selected) {
    setState(() => selectedDestination = selected);
  }

  ///Task title and description controller
  var titleController = TextEditingController();
  List<String> categories = ['Home', 'Work', 'Personal', 'Family'];

  ///The rest of the functions are managing the state of [TasksList] and [TasksDone] list.
  ///
  ///Returns true if [task] is successfully added.
  Future<bool> addTask(Task task) async {
    task.title = task.title.trim();
    if (task.title.isNotEmpty) {
      await DatabaseService.addTask(task);
      _refreshData();
      isNewTaskAdded = true;
      return true;
    }
    return false;
  }

  ///Delete  [thisTask] [fromThislist]
  Future<void> deleteFromList({required Task taskToDelete}) async {
    await DatabaseService.deleteTask(id: taskToDelete.id!);
    _refreshData();
  }

  ///Returns true if [task] is successfully edited.
  Future<bool> editTask({
    required Task task,
  }) async {
    var trimmed = task.title.trim();

    ///For some reason [trimmed.isEmpty] and [trimmed.isNotEmpty] were not working as expected and they were allowing to save an empty task, so I had to do this:
    if (trimmed.isNotEmpty) {
      await DatabaseService.editTask(task);
      _refreshData();
      return true;
    }
    return false;
  }

  Future<void> toggleDone(Task task) async {
    await DatabaseService.toggleDone(task);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return AppController(
      tasks: tasks,
      scrollController: scrollController,
      themeData: themeData,
      icon: icon,
      isDark: isDark,
      selectedNavigation: selectedDestination,
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
      required this.themeData,
      required this.icon,
      required this.isDark,
      required this.selectedNavigation,
      required this.titleController,
      required this.categories,
      required this.stateWidget});

  final List<Map<String, dynamic>> tasks;
  final ScrollController scrollController;
  final ThemeData themeData;
  final WidgetStateProperty<Icon> icon;
  final bool isDark;
  final int selectedNavigation;
  final TextEditingController titleController;
  final List<String> categories;
  final StateProvider stateWidget;
  @override
  @override
  bool updateShouldNotify(AppController oldWidget) {
    return tasks != oldWidget.tasks ||
        themeData != oldWidget.themeData ||
        selectedNavigation != oldWidget.selectedNavigation ||
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
