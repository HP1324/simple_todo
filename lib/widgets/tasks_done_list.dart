// import 'package:flutter/material.dart';
// import 'package:planner/globals.dart';
// import 'package:planner/models/task.dart';
// import 'package:planner/app_controller.dart';
// import 'package:planner/widgets/empty_list_placeholder.dart';
// import 'package:planner/widgets/task_tile.dart';
//
// class TasksDoneList extends StatefulWidget {
//   const TasksDoneList({super.key});
//
//   @override
//   State<TasksDoneList> createState() => _TasksDoneListState();
// }
//
// class _TasksDoneListState extends State<TasksDoneList> {
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String,dynamic>> tasksDone = AppController.of(context).tasksDone;
//     return tasksDone.isEmpty
//         ?const EmptyListPlaceholder()
//         : Scrollbar(
//             child: Padding(
//               padding: const EdgeInsets.only(bottom:50.0),
//               child: ListView(
//                 children: tasksDone
//                     .map(
//                       (task) => TaskTile(task: Task.fromJson(task)))
//                     .toList(),
//               ),
//             ),
//           );
//   }
// }
