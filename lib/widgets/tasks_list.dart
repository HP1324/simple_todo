import 'package:flutter/material.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/task.dart';
import 'package:planner/widgets/empty_list_placeholder.dart';
import 'package:planner/widgets/task_tile.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = AppController.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(provider.isNewTaskAdded) {
        provider.scrollController.jumpTo(provider.scrollController.position.maxScrollExtent);
        provider.isNewTaskAdded = false;
      }
    });
    var tasks = provider.tasks;
    return Column(
      children: [
        if (tasks.isEmpty) const Spacer(),
        if (tasks.isEmpty) const EmptyListPlaceholder(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Scrollbar(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskTile(task: Task.fromJson(tasks[index]));
                },
                controller: provider.scrollController,
              ),
            ),
          ),
        ),
        TextField(
          controller: provider.titleController,
          textInputAction: TextInputAction.done,
          autofocus: false,
          cursorColor: AppTheme.darkTeal,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            filled: true,
            fillColor: AppTheme.cardTeal,
            hintText: 'Tap here to add task on the go',
            hintStyle: TextStyle(color: AppTheme.darkTeal, fontSize: 16),
            border: InputBorder.none,
          ),
          onSubmitted: (value)async {
              Task task = Task(title: value);
            if (await provider.addTask(task)) {
              showSnackBar( content: 'Task added');
              provider.titleController.clear();
            } else {
              showSnackBar( content: 'Write something first');
              provider.titleController.clear();
            }
          },
        ),
      ],
    );
  }
}
