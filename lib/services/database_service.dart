import 'package:flutter/material.dart';
import 'package:planner/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      category TEXT,
      isDone INTEGER
      )""");
  }

  static Future<Database> openDb() async {
    return openDatabase('simple_todo.db', version: 1,
        onCreate: (database, version) async {
      await createTables(database);
    });
  }

  static Future<int> addTask(Task task) async {
    final database = await DatabaseService.openDb();
    final data = task.toJson();
    final id = await database.insert('tasks', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<void> toggleDone(Task task,) async {
    ///To maintain atomicity, which means when dealing with multiple transactions, all transactions must be completed or none should be completed. In our case, there are two transactions, one is to delete it from the previous list and the other is inserting the data to another list. [list == table]
    debugPrint('--------------------Inside DatabaseService.toggleDone()------------------');
    debugPrint('task parameter value : ${task.toJson()}');
    final database = await DatabaseService.openDb();
    int isDone = task.isDone ? 1 : 0;
    try {
      await database.update('tasks',{'isDone':isDone},where: 'id = ?', whereArgs: [task.id]);
    }catch(exception){
      debugPrint('something went wrong when marking taskAsDone: $exception');
    }

    debugPrint('--------------------End of DatabaseService.toggleDone()------------------');
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final database = await DatabaseService.openDb();
    return await database.query('tasks');
  }

  static Future<int> editTask(
      Task task) async {
    final database = await DatabaseService.openDb();
    final data = task.toJson();
    final result = await database
        .update('tasks', data, where: 'id = ?', whereArgs: [task.id]);
    return result;
  }

  static Future<void> deleteTask(
      {required int id,}) async {
    final database = await DatabaseService.openDb();
    try {
      await database.delete('tasks', where: 'id = ?', whereArgs: [id]);
    } catch (exception) {
      debugPrint('Something went wrong when deleting the task: $exception');
    }
  }
}
