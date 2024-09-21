import 'package:flutter/material.dart';

///Show [Snackbar] when adding tasks, deleting them, marking them as done or deleting them from marked as done list.

showSnackBar(
  BuildContext context, {
  required String content,
  Duration duration = const Duration(milliseconds: 800),
}) {
  ///removeCurrentSnackbar will prevent the snackbar from showing up multiple times when user does some operations(add, delete, mark as done) back to back.
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        content: Text(content),
        duration: duration,
      ),
    );
}

///Enum to tell the dialog either it is editing or creating a new task
enum EditMode {
  newTask,
  editTask,
}

enum ListType{
  tasksList,
  tasksDoneList,
}
