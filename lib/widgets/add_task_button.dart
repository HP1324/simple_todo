import 'package:flutter/material.dart';
import 'package:planner/widgets/task_editor_dialog.dart';

import '../models/task.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return TaskEditorDialog();
          },
        );
      },
      tooltip: 'Add Task',
      elevation: 6,
      shape: CircleBorder(),
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
