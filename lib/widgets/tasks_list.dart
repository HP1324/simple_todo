import 'package:flutter/material.dart';
import 'package:planner/global_functions.dart';
import 'package:planner/lists.dart';
import 'package:planner/models/task.dart';
import 'package:planner/widgets/shared/list_empty_text.dart';
import 'package:planner/widgets/task_editor_dialog.dart';

//I have created a global state from private state object of tasksList widget, although this approach is extremely discouraged and no one prefers to use this, I am okay with it for some time. When I will learn more robust approaches like Provider, Riverpod, BLoC or GetX, I will implement them. Never use this method for managing state of a widget from inside another widget which is located elsewhere in the widget tree.
late _TasksListState tasksListState;

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() {
    tasksListState = _TasksListState();
    return tasksListState;
  }
}

class _TasksListState extends State<TasksList> {
  var _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Task.getTasksList().isEmpty
        ? ListEmptyText()
        : Scrollbar(
            child: ListView(
              children: Task.getTasksList()
                  .map(
                    (task) => SizedBox(
                      height: 60,
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        color: Colors.green[50],
                        elevation: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              splashColor: Colors.green[200],
                              padding: EdgeInsets.all(0),
                              iconSize: 25,
                              onPressed: () {
                                setState(() {
                                  task.markAsDone();
                                  showSnackBar(context, content: 'Task marked as done');
                                });
                              },
                              icon: Icon(
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
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Edit task',),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Old title: ${task.title}',style: TextStyle(fontSize: 20),),
                                          TextField(
                                            controller: _titleController,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              labelText: 'New Title',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            maxLength: 40,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); //close the dialog
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              task.editTask(
                                                  title: _titleController.text);
                                              showSnackBar(context,
                                                  content:
                                                      'Task Edited Successfully');
                                            });
                                            _titleController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Save'),
                                        )
                                      ],
                                    ),
                                  );
                                });
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  task.deleteFromTaskList();
                                  showSnackBar(context, content: 'Task deleted Successfully');
                                });
                              },
                              icon: Icon(Icons.delete),
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
