import 'package:flutter/material.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/task.dart';
import 'package:planner/widgets/task_dialog.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.listType});
  final Task task;
  final ListType listType;
  final bool checked = false;
  @override
  Widget build(BuildContext context) {
    var provider = AppController.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
          leading: listType == ListType.tasksList
              ? Checkbox(
                  value: task.isDone,
                  onChanged: (newValue) {
                    if (!task.isDone) {
                      Future.delayed(const Duration(milliseconds: 800), () {
                        provider.markTaskAsDone(task);
                        showSnackBar(context, content: 'Task marked as done');
                      });
                      provider.setChecked(task, newValue!);
                    }
                  })
              : null,
          title: Text(task.title),
          trailing: PopupMenuButton(
            itemBuilder: (context) {
              return [
                if (listType == ListType.tasksDoneList)
                  PopupMenuItem(
                    onTap: () {
                      Future.delayed(const Duration(seconds: 1), () {
                        provider.markTaskAsUnDone(task);
                      });
                      showSnackBar(context,
                          content:
                              'Task marked as undone and added to the last of tasks to do list');
                    },
                    child: const Text('Mark as undone'),
                  ),
                if (listType == ListType.tasksList)
                  PopupMenuItem(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return TaskDialog(
                                task: task, editMode: EditMode.editTask);
                          });
                    },
                    child: const Text('Edit'),
                  ),
                PopupMenuItem(
                  onTap: () {
                    if (listType == ListType.tasksList) {
                      provider.deleteFromTasksList(task);
                      showSnackBar(context, content: 'Task deleted !');
                    }
                    if (listType == ListType.tasksDoneList) {
                      provider.deleteFromTasksDoneList(task);
                      showSnackBar(context, content: 'Task deleted !');
                    }
                  },
                  child: const Text('Delete'),
                ),
              ];
            },
          )),
    );
  }
}
