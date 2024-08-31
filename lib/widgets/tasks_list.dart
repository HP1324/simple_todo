import 'package:flutter/material.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/globals.dart';
import 'package:planner/widgets/shared/list_empty_text.dart';
import 'package:planner/widgets/task_dialog.dart';

class TasksList extends StatelessWidget {
  TasksList({super.key});

  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var tasks = AppController.of(context).tasks;
    var provider = AppController.of(context);
    return tasks.isEmpty
        ? const ListEmptyText()
        : Scrollbar(
            child: ListView(
              children: tasks
                  .map(
                    (task) => SizedBox(
                      height: 70,
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        elevation: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              padding: const EdgeInsets.all(5),
                              iconSize: 25,
                              onPressed: () {
                                provider.markTaskAsDone(task);
                                showSnackBar(context,
                                    content: 'Task marked as done');
                              },
                              icon: const Icon(
                                Icons.done,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                task.title,
                                maxLines: null,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return TaskDialog(
                                        editMode: EditMode.editTask,
                                        task: task,
                                      );
                                    });
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                provider.deleteFromTasksList(task);
                                showSnackBar(context,
                                    content: 'Task deleted Successfully');
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
  }
}
