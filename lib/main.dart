import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/providers/category_provider.dart';
import 'package:planner/providers/navigation_provider.dart';
import 'package:planner/providers/task_provider.dart';
import 'package:planner/widgets/task_editor_page.dart';
import 'package:planner/widgets/tasks_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const SimpleTodo());
}

class SimpleTodo extends StatelessWidget {
  const SimpleTodo({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightMode,
        darkTheme: AppTheme.darkMode,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        title: 'MinimalTodo',
        home: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: TasksList(),
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );
  }


  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: MediaQuery.sizeOf(context).height * 0.077,
      title: const Text('Planner'),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.topToBottom,
              child: TaskEditorPage(
                editMode: false,
              ),
            ),
          );
        },
        tooltip: 'Add Task',
        elevation: 6,
        shape: const CircleBorder(),
        // backgroundColor: Colors,
        child: const Icon(
          Icons.add,
          color: Color(0xffffffff),
        ),
      ),
    );
  }
}
