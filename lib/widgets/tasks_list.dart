import 'package:flutter/material.dart';
import 'package:planner/app_theme.dart';
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
    var provider = Provider.of<TaskProvider>(context, listen: true);
    var tasks = provider.allTasks;
    return Column(
      children: [
        if (tasks.isNotEmpty || provider.filterFlag != 0)
          const Row(
            children: [
              _TaskFilterChip(label: 'Done'),
              _TaskFilterChip(label: 'Undone'),
            ],
          ),
        if (tasks.isEmpty) const Spacer(),
        if (tasks.isEmpty) const EmptyListPlaceholder(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Scrollbar(
              child: Consumer<TaskProvider>(
                builder: (_, taskProvider, child) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (taskProvider.isNewTaskAdded && taskProvider.filterFlag != 1) {
                      scrollController.animateTo(scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500), curve: Curves.easeInExpo);
                      taskProvider.isNewTaskAdded = false;
                    }
                  });
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: tasks.length,
                    itemBuilder: (_, index) {
                      return TaskItem(task: Task.fromJson(tasks[index]));
                    },
                  );
                },
              ),
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
            var messenger = ScaffoldMessenger.of(context);
            Task task = Task(title: value, categoryId: 1);
            if (await provider.addTask(task)) {
              debugPrint('|||||||||| Inside of onSubmitted |||||||||||');
              showSnackBar(messenger, content: 'Task added');
              titleController.clear();
            } else {
              showSnackBar(messenger, content: 'Write something first');
              focusNode.requestFocus();
              titleController.clear();
            }
          },
        ),
      ],
    );
  }
}

class _TaskFilterChip extends StatelessWidget {
  const _TaskFilterChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Consumer<TaskProvider>(
        builder: (_, provider, __) {
          var selectedChip = provider.chipSelection[label];
          return FilterChip(
            selected: selectedChip!,
            onSelected: (selected) {
              provider.toggleSelected(label, selected);
            },
            label: Text(
              label,
              style: TextStyle(
                color: selectedChip ? Colors.white : Colors.black,
              ),
            ),
            selectedColor: AppTheme.darkTeal,
            checkmarkColor: Colors.white,
            backgroundColor: AppTheme.tealShade100,
            side: BorderSide.none,
          );
        },
      ),
    );
  }
}
