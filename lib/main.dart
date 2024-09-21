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
      title: 'MinimalTodo',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildTabBarView(context),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  dynamic buildFloatingActionButton(BuildContext context) {
    var provider = AppController.of(context);
    if (provider.tabController.index == 0) {
      return FloatingActionButton(
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
      );
    }
    return null;
  }

  TabBarView buildTabBarView(BuildContext context) {
    var provider = AppController.of(context);
    return TabBarView(
      controller: provider.tabController,
      children: [
        TasksList(),
        TasksDoneList(),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    var provider = AppController.of(context);
    return AppBar(
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
        indicatorSize: TabBarIndicatorSize.tab,
        controller: provider.tabController,
        splashBorderRadius: BorderRadius.circular(10),
        indicatorWeight: 7,
        tabs: [
          Tab(
            child: const Text(
              'To do',
            ),
          ),
          Tab(
            child: const Text(
              'Done',
            ),
          ),
        ],
      ),
    );
  }
}
