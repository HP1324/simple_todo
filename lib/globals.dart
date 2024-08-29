import 'package:flutter/material.dart';
import 'package:planner/task_list_state_manager.dart';


///Show [Snackbar] when adding tasks, deleting them, marking them as done or deleting them from marked as done list.
showSnackBar(
  BuildContext context, {
  required String content,
  Duration duration = const Duration(seconds: 1),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin:const EdgeInsets.symmetric(horizontal: 10),
      content: Text(content),
      duration: duration,
    ),
  );
}
