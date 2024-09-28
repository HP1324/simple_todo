import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/widgets/task_editor_page.dart';
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
    return GetMaterialApp(
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
      body: [
        const TasksList(),
        const Text('Text'),
      ][provider.selectedDestination],
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: provider.selectedDestination,
        height: MediaQuery.sizeOf(context).height * 0.0972,
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.task), label: 'Todo'),
          NavigationDestination(icon: Icon(Iconsax.setting), label: 'Settings'),
        ],
        onDestinationSelected: (selected) =>
            provider.onDestinationSelected(selected),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom:40.0),
      child: FloatingActionButton(
        onPressed: () {
          Get.to(()=>TaskEditorPage(editMode: EditMode.newTask),transition: Transition.rightToLeft,);
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

  AppBar buildAppBar(BuildContext context) {
     var provider = AppController.of(context) ;
    return AppBar(
      toolbarHeight: MediaQuery.sizeOf(context).height * 0.097222,
      elevation: 5,
      title: const Text(
        'Planner',
      ),
      actions: [
        Switch(
          value: provider.isDark,
          onChanged: (newValue) {
            provider.toggleTheme(newValue);
          },
          activeColor: Color(0x414141),
          thumbIcon: provider.icon,

        ),
      ],
    );
  }
}
