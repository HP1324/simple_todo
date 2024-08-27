import 'package:flutter/material.dart';

class ListEmptyText extends StatelessWidget {
  const ListEmptyText({super.key, this.text = 'No tasks to show'});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.task,
          size: 100,
          color: Colors.blue.shade100,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 20,color: Colors.blue.shade200),
        ),
      ],
    );
  }
}
