import 'package:flutter/cupertino.dart';
import 'package:planner/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      isDone INTEGER
      )""");
    await database.execute("""CREATE TABLE IF NOT EXISTS tasksDone (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      title TEXT NOT NULL DEFAULT '',
      isDone INTEGER
    )""");
  }

  static Future<Database> openDb() async {
    return openDatabase('simple_todo.db', version: 1,
        onCreate: (database, version) async {
      await createTables(database);
    });
  }

  static Future<int> addTask(String? title, bool? isDone) async {
    final database = await DatabaseService.openDb();
    final data = {'title': title, 'isDone': isDone == true ? 1 : 0};
    final id = await database.insert('tasks', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<void> toggleDone(Task task, String tableName) async {
    ///To maintain atomicity, which means when dealing with multiple transactions, all transactions must be completed or none should be completed. In our case, there are two transactions, one is to delete it from the previous list and the other is inserting the data to another list. [list == table]
    final database = await DatabaseService.openDb();
    try {
      if (tableName == 'tasks') {
        database.transaction((txn) async {
          await txn.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
          ///Managing isDone status to 1 or 0 in database, not in the controller or the view
          await txn.insert('tasksDone', {'title': task.title,'isDone': 1});
        });
      }
      if (tableName == 'tasksDone') {
        database.transaction((txn) async {
          await txn
              .delete('tasksDone', where: 'id = ?', whereArgs: [task.id]);

          ///Managing isDone status to 1 or 0 in database, not in the controller or the view
          await txn.insert('tasks', {'title': task.title, 'isDone': 0});
        });
      }
    } catch (exception) {
      print('Error toggling taskdone status: $exception');
    }
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final database = await DatabaseService.openDb();
    return database.query('tasks');
  }

  static Future<List<Map<String, dynamic>>> getTasksDone() async {
    final database = await DatabaseService.openDb();
    return database.query('tasksDone');
  }

  static Future<int> editTask(
      Task task, String newTitle, bool? isDone) async {
    final database = await DatabaseService.openDb();
    final data = {'title': newTitle, 'isDone': isDone == true ? 1 : 0};
    final result = await database
        .update('tasks', data, where: 'id = ?', whereArgs: [task.id]);
    return result;
  }

  static Future<void> deleteTask(
      {required int id, required String tableName}) async {
    final database = await DatabaseService.openDb();
    try {
      await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
    } catch (exception) {
      debugPrint('Something went wrong when deleting the task: $exception');
    }
  }
}
