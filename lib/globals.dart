import 'package:flutter/material.dart';

///Show [Snackbar] when adding tasks, deleting them, marking them as done or undone.

showSnackBar(
  ScaffoldMessengerState scaffoldMessenger, {
  required String content,
  Duration duration = const Duration(milliseconds: 1000),
}) {
  ///removeCurrentSnackbar will prevent the snackbar from showing up multiple times when user does some operations(add, delete, mark as done) back to back.
  scaffoldMessenger
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        // margin: const EdgeInsets.fromLTRB(14, 0, 14, 45),
        content: Text(content, style: const TextStyle(fontSize: 15)),
        duration: duration,
      ),
    );
}
