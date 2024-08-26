import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Planner',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                'No tasks to show',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 60,
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    color: Colors.blue.shade100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          iconSize: 30,
                          highlightColor: Colors.blue.shade200,
                          tooltip: 'Mark as Completed',
                          icon: Icon(
                            Icons.done,
                          ),
                          onPressed: () {
                            //Use future to not immediately remove it from the list and delay the remove for 800 milliseconds,to avoid leaving the user wondering about where the task went.
                            Task taskDone = tasks[index];
                            Future.delayed(Duration(milliseconds: 800), () {
                              setState(() {
                                //remove the task that is done from tasks list
                                // print(' index : $index');

                                if (!taskDone.isDone!) {
                                  tasksDone.add(taskDone);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(milliseconds: 800),
                                    content: Text('Task marked as done'),
                                  ));
                                }
                                taskDone.isDone = true;
                                tasks.remove(taskDone);
                                //Show snack bar
                              });
                            });
                          },
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width * 0.65,
                            ),
                            child: Text(
                              '${tasks[index].title}',
                              maxLines: null,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Edit',
                          onPressed: () {},
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete_outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 1,
        elevation: 4,
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        child: Row(
          children: [
            Text(
              'Tasks',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Spacer(),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text(
                                    'Tasks done',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                                body: ListView.builder(
                                  itemCount: tasksDone.length,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      height: 60,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        elevation: 1,
                                        color: Colors.blue[50],
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${tasksDone[index].title}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0),
                                              child: Icon(
                                                Icons.done,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )));
                },
                child: Text(
                  'Completed',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.blue.shade50,
                  title: Text('Add new Task'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        autofocus: true,
                        decoration: InputDecoration(
                            labelText: 'Task title',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        maxLength: 30,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        titleController.clear();
                        Navigator.of(context).pop(); //close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          titleController.text.isNotEmpty
                              ? tasks.add(Task(title: titleController.text))
                              : null;
                        });
                        titleController.clear();
                        Navigator.of(context).pop(); //close the dialog
                      },
                      child: Text('Save'),
                    )
                  ],
                );
              });
        },
        tooltip: 'Add Task',
        elevation: 6,
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  List<Task> tasks = [
    Task(title: "Buy groceries"),
    Task(title: "Call mom"),
    Task(title: "Finish homework"),
    Task(title: "Clean the kitchen"),
    Task(title: "Walk the dog"),
    Task(title: "Pay bills"),
    Task(title: "Read a book"),
    Task(title: "Water the plants"),
    Task(title: "Send an email"),
    Task(title: "Organize desk"),
    Task(title: "Plan the weekend"),
    Task(title: "Exercise for 30 mins"),
    Task(title: "Review notes"),
    Task(title: "Schedule a meeting"),
    Task(title: "Update resume"),
    Task(title: "Write a blog post"),
    Task(title: "Backup files"),
    Task(title: "Prepare lunch"),
    Task(title: "Meditate for 10 mins"),
    Task(title: "Change the light bulb"),
    Task(title: "Check the mail"),
    Task(title: "Attend a webinar"),
    Task(title: "Plan a trip"),
    Task(title: "Buy a gift"),
    Task(title: "Watch a tutorial"),
    Task(title: "Respond to comments"),
    Task(title: "Prepare a presentation"),
    Task(title: "Review the budget"),
    Task(title: "Call the plumber"),
    Task(title: "Draft an article"),
    Task(title: "Sort out laundry"),
    Task(title: "Update software"),
    Task(title: "Organize a meeting"),
    Task(title: "Test the new app"),
    Task(title: "Print documents"),
    Task(title: "Book a flight"),
    Task(title: "Write a thank you note"),
    Task(title: "Check stock prices"),
    Task(title: "Update social media"),
    Task(title: "Clean the car"),
  ];
  List<Task> tasksDone = [];
}

class Task {
  Task({required this.title, this.isDone = false});

  final String title;
  bool? isDone;

  @override
  String toString() {
    return '${this.title} : ${isDone.toString()}';
  }
}
