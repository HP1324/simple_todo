import 'package:flutter/material.dart';
import 'package:planner/app_theme.dart';

class EmptyListPlaceholder extends StatelessWidget {
  const EmptyListPlaceholder({super.key, this.text = 'No tasks to show'});
  final String text;
  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.task_rounded,
      size: 115,
      color: AppTheme.tealShade100,
    );
  }
}
