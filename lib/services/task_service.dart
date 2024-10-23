import 'package:flutter/material.dart';
import 'package:planner/models/task.dart';
import 'package:planner/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class TaskService {
  static Future<List<Map<String, dynamic>>> getTasks() async {
    final database = await DatabaseService.openDb();

    return await database.query('tasks');
  }

  static Future<void> addTask(Task task) async {
    final database = await DatabaseService.openDb();
    final data = task.toJson();
    debugPrint('Task adding to database ->-> $data');
    await database.insert('tasks', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> toggleDone(Task task) async {
    final database = await DatabaseService.openDb();
    int isDone = task.isDone ? 1 : 0;
    try {
      await database.update('tasks', {'isDone': isDone},
          where: 'id = ?', whereArgs: [task.id]);
    } catch (exception) {
      debugPrint('something went wrong when marking taskAsDone: $exception');
    }
  }

  static Future<int> editTask(Task task) async {
    final database = await DatabaseService.openDb();
    final data = task.toJson();
    final result = await database
        .update('tasks', data, where: 'id = ?', whereArgs: [task.id]);
    return result;
  }

  static Future<void> deleteTask({required int id}) async {
    final database = await DatabaseService.openDb();
    try {
      await database.delete('tasks', where: 'id = ?', whereArgs: [id]);
    } catch (exception) {
      debugPrint('Something went wrong when deleting the task: $exception');
    }
  }

}
