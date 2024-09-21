import 'package:flutter/material.dart';

class EmptyListPlaceholder extends StatelessWidget {
  const EmptyListPlaceholder({super.key, this.text = 'No tasks to show'});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task,
            size: 100,
            color: Colors.grey,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 20,color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
