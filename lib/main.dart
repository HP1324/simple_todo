
import 'package:flutter/material.dart';
import 'package:planner/widgets/add_task_button.dart';
import 'package:planner/widgets/tasks_done_list.dart';
import 'package:planner/widgets/tasks_list.dart';

import 'models/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {setState(() {});});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  void _onTaskAdded(Task task){
    setState(() {
      task.addToTaskList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text(
          'Planner',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        bottom:TabBar(
          controller: _tabController,
          splashBorderRadius: BorderRadius.circular(50),
          indicatorColor: Colors.blue[50],
          indicatorWeight: 7,
          tabs: [
            Tab(
              child: Text(
                'Tasks to do',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                'Tasks done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TasksList(),
          TasksDoneList(),
        ],
      ),
      floatingActionButton: _tabController.index == 0 ? AddTaskButton(onTaskAdded: _onTaskAdded,) : null,
    );
  }
}
