import 'package:flutter/material.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/task.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/widgets/shared/list_empty_text.dart';

class TasksDoneList extends StatefulWidget {
  const TasksDoneList({super.key});

  @override
  State<TasksDoneList> createState() => _TasksDoneListState();
}

class _TasksDoneListState extends State<TasksDoneList> {
  @override
  Widget build(BuildContext context) {
    List<Task> tasksDone = AppController.of(context).tasksDone;
    var provider = AppController.of(context);
    return tasksDone.isEmpty
        ?const ListEmptyText()
        : Scrollbar(
            child: ListView(
              children: tasksDone
                  .map(
                    (task) => Card(
                      margin:const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      elevation: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              maxLines: null,
                              style:const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                          IconButton(
                            splashColor: Colors.green[200],
                            onPressed: () {
                                provider.deleteFromTasksDoneList(task);
                                showSnackBar(context,
                                    content: 'Task deleted completely');
                            },
                            icon:const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
  }
}
