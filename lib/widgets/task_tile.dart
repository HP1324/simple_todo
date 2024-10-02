import 'package:flutter/material.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/task.dart';
import 'package:planner/providers/task_provider.dart';
import 'package:planner/widgets/task_editor_page.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    var readProvider = context.watch<TaskProvider>();
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        leading: Checkbox(
          value: task.isDone,
          onChanged: (newValue) async {
            var scaffoldMessenger = ScaffoldMessenger.of(context);
            showSnackBar(scaffoldMessenger,
                content:
                    task.isDone ? 'Task marked undone' : 'Task marked as done');
            readProvider.toggleChecked(task, newValue);
            await readProvider.toggleDone(task);
          },
        ),
        title: Text(task.title),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (_) => TaskEditorPage(editMode: true,)));
                },
                child: const Text(
                  'Edit',
                  style: AppTheme.popupItemStyle,
                ),
              ),
              PopupMenuItem(
                onTap: () async {
                  var scaffoldMessenger = ScaffoldMessenger.of(context);
                  showSnackBar(scaffoldMessenger, content: 'Task deleted !');
                  await Future.delayed(const Duration(milliseconds: 300),
                      () => readProvider.deleteTask(taskToDelete: task));
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
