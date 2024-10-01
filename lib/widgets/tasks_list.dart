import 'package:flutter/material.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/globals.dart';
import 'package:planner/main.dart';
import 'package:planner/models/task.dart';
import 'package:planner/providers/task_provider.dart';
import 'package:planner/widgets/planner_text_field.dart';
import 'package:planner/widgets/empty_list_placeholder.dart';
import 'package:planner/widgets/task_tile.dart';
import 'package:provider/provider.dart';
//ignore: must_be_immutable
class TasksList extends StatelessWidget {
  TasksList({super.key});
  var titleController = TextEditingController();
  var scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var watchProvider = context.watch<TaskProvider>();
    var readProvider = context.read<TaskProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(watchProvider.isNewTaskAdded) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
        watchProvider.isNewTaskAdded = false;
      }
    });
    var tasks = watchProvider.tasks;
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
                controller: scrollController,
              ),
            ),
          ),
        ),
        PlannerTextField(
          controller: titleController,
          isMaxLinesNull: false,
          isAutoFocus: false,
          hintText: 'Tap here to add task on the go',
          onSubmitted: (value)async {
              var scaffoldMessenger = ScaffoldMessenger.of(context);
              Task task = Task(title: value);
            if (await readProvider.addTask(task)) {
              showSnackBar(scaffoldMessenger, content: 'Task added');
              titleController.clear();
            } else {
              showSnackBar(scaffoldMessenger, content: 'Write something first');
              titleController.clear();
            }
          },
        ),
      ],
    );
  }
}
