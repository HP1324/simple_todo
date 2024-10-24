import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/task.dart';
import 'package:planner/providers/task_provider.dart';
import 'package:planner/widgets/task_editor_page.dart';
import 'package:provider/provider.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task});
  final Task task;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TaskProvider>(context, listen: false);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: CheckboxListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        controlAffinity: ListTileControlAffinity.leading,
        value: task.isDone,
        selected: task.isDone,
        selectedTileColor: AppTheme.tealShade100,
        enableFeedback: true,
        onChanged: (newValue) async {
          debugPrint('isDone before marking done: ${task.isDone}');
          var messenger = ScaffoldMessenger.of(context);
          await provider.toggleDone(task, newValue!).then((_){
            showSnackBar(messenger,content: newValue ? 'Task marked as done' : 'Task marked undone');
          });
          debugPrint('isDone after marking done: ${task.isDone}');
        },
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        title: Text(task.title),
        secondary: PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: TaskEditorPage(
                        editMode: true,
                        taskToEdit: task,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Edit',
                  style: AppTheme.popupItemStyle,
                ),
              ),
              PopupMenuItem(
                onTap: () async {
                  var messenger = ScaffoldMessenger.of(context);
                  showSnackBar(messenger, content: 'Task deleted !');
                  await Future.delayed(const Duration(milliseconds: 300),
                      () => provider.deleteTask(taskToDelete: task));
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
