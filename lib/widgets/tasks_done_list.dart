import 'package:flutter/material.dart';
import 'package:planner/global_functions.dart';
import 'package:planner/models/task.dart';
import 'package:planner/widgets/shared/list_empty_text.dart';

class TasksDoneList extends StatefulWidget {
  const TasksDoneList({super.key});

  @override
  State<TasksDoneList> createState() => _TasksDoneListState();
}

class _TasksDoneListState extends State<TasksDoneList> {
  @override
  Widget build(BuildContext context) {
    return Task.getTasksDoneList().isEmpty
        ? ListEmptyText()
        : Scrollbar(
            child: ListView(
              children: Task.getTasksDoneList()
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
                              setState(() {
                                task.deleteFromTasksDoneList();
                                showSnackBar(context,
                                    content: 'Task deleted completely');
                              });
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
