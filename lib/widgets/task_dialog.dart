import 'package:flutter/material.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/task.dart';

class TaskDialog extends StatelessWidget {
  const TaskDialog({super.key, required this.editMode, this.task});
  final EditMode editMode;
  ///Optional [task] parameter for editing task, because to edit the task, the task must be provided,and [TaskList] will provide that
  final Task? task;
  Text _setTitle() => editMode == EditMode.newTask
      ? const Text('New Task')
      : const Text('Edit Task');
  @override
  Widget build(BuildContext context) {
    var titleController = TextEditingController();
    var provider = AppController.of(context);
    return AlertDialog(
      title: _setTitle(),
      content: TextField(
        controller: titleController,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Task title',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        maxLength: 100,
        maxLines: null,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
            onPressed: () {
              if (editMode == EditMode.newTask) {
                Task task = Task(title: titleController.text);
                if (provider.addTask(task)) {
                  Navigator.of(context).pop();
                  showSnackBar(context, content: 'Task added successfully');
                }
              }
              if (editMode == EditMode.editTask) {
                if (provider.editTask(task!, newTitle: titleController.text)) {
                Navigator.of(context).pop();
                  showSnackBar(context, content: 'Task edited successfully');
                }
              }
            },
            child: const Text('Save')),
      ],
    );
  }
}