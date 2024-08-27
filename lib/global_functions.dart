import 'package:flutter/material.dart';

showSnackBar(
  BuildContext context, {
  required String content,
  Duration duration = const Duration(seconds: 1),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(horizontal: 10),
      content: Text(content),
      duration: duration,
    ),
  );
}
