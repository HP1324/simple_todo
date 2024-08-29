import 'package:flutter/material.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/task.dart';
import 'package:planner/task_list_state_manager.dart';
import 'package:planner/widgets/shared/list_empty_text.dart';

class TasksDoneList extends StatefulWidget {
  const TasksDoneList({super.key});

  @override
  State<TasksDoneList> createState() => _TasksDoneListState();
}

class _TasksDoneListState extends State<TasksDoneList> {
  @override
  Widget build(BuildContext context) {
    List<Task> tasksDone = TaskListStateManager.of(context).tasksDone;
    var provider = TaskListStateManager.of(context);
    return tasksDone.isEmpty
        ? ListEmptyText()
        : Scrollbar(
            child: ListView(
              children: tasksDone
                  .map(
                    (task) => Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      elevation: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            task.title,
                            maxLines: null,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          IconButton(
                            splashColor: Colors.green[200],
                            onPressed: () {
                                provider.deleteFromTasksDoneList(task);
                                showSnackBar(context,
                                    content: 'Task deleted completely');
                            },
                            icon: Icon(Icons.delete),
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
