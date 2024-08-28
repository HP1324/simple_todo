import 'package:flutter/material.dart';
import 'package:planner/global_functions.dart';
import 'package:planner/models/task.dart';

class TaskEditorDialog extends StatelessWidget {
  TaskEditorDialog({super.key, required this.onTaskAdded});
  final Function(Task) onTaskAdded;
  final _titleController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade50,
      title: Text('Add new Task'),
      content: TextField(
        controller: _titleController,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Task title',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        maxLength: 40,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); //close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Task task = Task(title: _titleController.text);
            ///I have created a global state [tasksListState] from private state object of tasksList widget, although this approach is extremely discouraged and no one prefers to use this, I am okay with it for some time. When I will learn more robust approaches like Provider, Riverpod, BLoC or GetX, I will implement them. Never use this method for managing state of a widget from inside another widget which is located elsewhere in the widget tree.

            /// Edit: now I am using a callback method to manage the state, still this is not good, because it is the callback hell.
            if (task.isValid()) {
              onTaskAdded(task);
              showSnackBar(context, content: 'Task added successfully');
              Navigator.of(context).pop();
            }
          },
          child: Text('Save'),
        )
      ],
    );
  }
}
