import 'package:flutter/material.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/task.dart';
import 'package:planner/widgets/shared/empty_list_placeholder.dart';
import 'package:planner/widgets/shared/task_tile.dart';

class TasksList extends StatelessWidget {
  TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    var tasks = AppController.of(context).tasks;
    return tasks.isEmpty
        ? const EmptyListPlaceholder()
        : Scrollbar(
            child: ListView(
              children: tasks
                  .map(
                    (task) => TaskTile(
                      task: Task.fromJson(task),
                      listType: ListType.tasksList,
                    ),
                  )
                  .toList(),
            ),
          );
  }
}
