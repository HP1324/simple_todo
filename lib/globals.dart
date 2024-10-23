import 'package:flutter/material.dart';

///Show [Snackbar] when adding tasks, deleting them, marking them as done or deleting them from marked as done list.

showSnackBar(
  ScaffoldMessengerState scaffoldMessenger, {
  required String content,
  Duration duration = const Duration(milliseconds: 1100),
}) {
  ///removeCurrentSnackbar will prevent the snackbar from showing up multiple times when user does some operations(add, delete, mark as done) back to back.
  scaffoldMessenger
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(content),
      duration: duration,
    ));
}

