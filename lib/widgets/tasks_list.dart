import 'package:flutter/material.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/task.dart';
import 'package:planner/providers/task_provider.dart';
import 'package:planner/widgets/planner_text_field.dart';
import 'package:planner/widgets/empty_list_placeholder.dart';
import 'package:planner/widgets/task_item.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class TasksList extends StatelessWidget {
  TasksList({super.key});
  var titleController = TextEditingController();
  var scrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    var readProvider = context.read<TaskProvider>();
    var tasks = context.watch<TaskProvider>().tasks;
    return Column(
      children: [
        if (tasks.isEmpty) const Spacer(),
        if (tasks.isEmpty) const EmptyListPlaceholder(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Scrollbar(
              child: Consumer<TaskProvider>(builder: (_, taskProvider, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (taskProvider.isNewTaskAdded) {
                    scrollController
                        .jumpTo(scrollController.position.maxScrollExtent);
                    taskProvider.isNewTaskAdded = false;
                  }
                });
                return ListView.builder(
                  controller: scrollController,
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskTile(task: Task.fromJson(tasks[index]));
                  },
                );
              }),
            ),
          ),
        ),
        PlannerTextField(
          controller: titleController,
          focusNode: focusNode,
          isMaxLinesNull: false,
          isAutoFocus: false,
          hintText: 'Tap here to add task on the go',
          onSubmitted: (value) async {
            var scaffoldMessenger = ScaffoldMessenger.of(context);
            Task task = Task(title: value, categoryId: 1);
            if (await readProvider.addTask(task)) {
              debugPrint('|||||||||| Inside of onSubmitted |||||||||||');
              showSnackBar(scaffoldMessenger, content: 'Task added');
              titleController.clear();
            } else {
              showSnackBar(scaffoldMessenger, content: 'Write something first');
              focusNode.requestFocus();
              titleController.clear();
            }
          },
        ),
      ],
    );
  }
}

