import 'package:flutter/material.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/task.dart';
import 'package:planner/widgets/task_dialog.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.listType});
  final Task task;
  final ListType listType;

  @override
  Widget build(BuildContext context) {
    var provider = AppController.of(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
          contentPadding: const EdgeInsets.all(5),
          leading: listType == ListType.tasksList
              ? Checkbox(
                  value: task.isDone,
                  onChanged: (newValue) {
                    Future.delayed(const Duration(milliseconds: 800), () {
                      provider.toggleDone(task, 'tasks');
                      showSnackBar(context, content: 'Task marked as done');
                    });
                    print('isDone: ${task.isDone.hashCode}');
                    provider.setChecked(task.isDone, newValue!);
                  })
              : null,
          title: Text(task.title),
          trailing: PopupMenuButton(
            position: PopupMenuPosition.under,
            popUpAnimationStyle: AnimationStyle(
              duration: const Duration(milliseconds: 500),
              reverseDuration: const Duration(milliseconds: 100),
              curve: Curves.easeOutQuad,
              reverseCurve: Curves.easeIn,
            ),
            itemBuilder: (context) {
              return [
                if (listType == ListType.tasksDoneList)
                  PopupMenuItem(
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 800), () {
                        print(" this is the value : ${task.isDone}");
                        provider.toggleDone(task, 'tasksDone');
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
                      provider.deleteFromList(
                          thisTask: task, fromThisList: 'tasks');
                    }
                    if (listType == ListType.tasksDoneList) {
                      provider.deleteFromList(
                          thisTask: task, fromThisList: 'tasksDone');
                    }
                    showSnackBar(context, content: 'Task deleted !');
                  },
                  child: const Text('Delete'),
                ),
              ];
            },
          )),
    );
  }
}
