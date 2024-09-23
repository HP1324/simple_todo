import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/widgets/task_dialog.dart';
import 'package:planner/widgets/tasks_done_list.dart';
import 'package:planner/widgets/tasks_list.dart';
import 'package:planner/globals.dart';

void main() {
  runApp(const Provider(
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
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = AppController.of(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: [const TasksList(), const TasksDoneList()][provider.selectedDestination],
      floatingActionButton: buildFloatingActionButton(context),
      bottomNavigationBar: NavigationBar(
        selectedIndex: provider.selectedDestination,
        height: 70,
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.task), label: 'Todo'),
          NavigationDestination(icon: Icon(Icons.done_all), label: 'Done'),
        ],
        onDestinationSelected: (selected) =>
            provider.onDestinationSelected(selected),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return const TaskDialog(
                editMode: EditMode.newTask,
              );
            });
      },
      tooltip: 'Add Task',
      elevation: 6,
      shape: const CircleBorder(),
      // backgroundColor: Colors,
      child: const Icon(
        Icons.add,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      elevation: 5,
      title: const Text(
        'Planner',
      ),
      actions: [
        IconButton(
            onPressed: () {
              AppController.of(context).toggleTheme();
            },
            icon: const Icon(Icons.light_mode))
      ],
    );
  }
}
