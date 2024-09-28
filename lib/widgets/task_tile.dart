import 'package:flutter/material.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/task.dart';
import 'package:planner/widgets/task_editor_page.dart';
import 'package:get/get.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    var provider = AppController.of(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        leading: Checkbox(
          value: task.isDone,
          onChanged: (newValue) async {
            showSnackBar(context,
                content:
                    task.isDone ? 'Task marked undone' : 'Task marked as done');
            provider.toggleChecked(task, newValue);
            await provider.toggleDone(task);
          },
        ),
        title: Text(task.title),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  Get.to(TaskEditorPage(task: task, editMode: EditMode.editTask),transition: Transition.downToUp);
                },
                child: Text(
                  'Edit',
                  style: AppTheme.popupItemStyle,
                ),
              ),
              PopupMenuItem(
                onTap: () async {
                  showSnackBar(context, content: 'Task deleted !');
                  await Future.delayed(const Duration(milliseconds: 300),
                      () => provider.deleteFromList(taskToDelete: task));
                },
                child: const Text('Delete', style: AppTheme.popupItemStyle),
              ),
            ];
          },
        ),
      ),
    );
  }
}
