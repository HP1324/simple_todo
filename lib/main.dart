import 'package:flutter/material.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/widgets/task_dialog.dart';
import 'package:planner/widgets/tasks_done_list.dart';
import 'package:planner/widgets/tasks_list.dart';
import 'package:planner/globals.dart';

void main() {
  runApp(const AppStateProvider(
    child: SimpleTodo(),
  ));
}

class SimpleTodo extends StatelessWidget {
  const SimpleTodo({super.key});
  @override
  Widget build(BuildContext context) {
    var provider = AppController.of(context);
    return MaterialApp(
      theme: provider.themeData,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const Home(title: 'Flutter Demo Home Page'),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    var provider = AppController.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text(
          'Planner',
        ),
        actions: [
          IconButton(
              onPressed: () {
                AppController.of(context).toggleTheme();
              },
              icon: Icon(Icons.light_mode))
        ],
        bottom: TabBar(
          controller: provider.tabController,
          splashBorderRadius: BorderRadius.circular(50),
          indicatorWeight: 7,
          tabs: [
            Tab(
              child: const Text(
                'Tasks to do',
              ),
            ),
            Tab(
              child: const Text(
                'Tasks done',
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller : provider.tabController,
        children: [
          TasksList(),
          TasksDoneList(),
        ],
      ),
      floatingActionButton: provider.tabController.index == 0
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return TaskDialog(
                        editMode: EditMode.newTask,
                      );
                    });
              },
              tooltip: 'Add Task',
              elevation: 6,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
              ),
            )
          : null,
    );
  }
}
