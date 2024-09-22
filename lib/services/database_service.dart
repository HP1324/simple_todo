import 'package:flutter/cupertino.dart';
import 'package:planner/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE tasks (
      title text,
      isDone int
      )""");
    await database.execute("""CREATE TABLE tasksDone (
      title text,
      isDone int
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
    try {
      final database = await DatabaseService.openDb();
      if (tableName == 'tasks') {
        database.transaction((txn) async {
          await txn.delete('tasks', where: 'title = ?', whereArgs: [task.title]);
          await txn.insert('tasksDone', {'title': task.title, 'isDone': 1});
        });
      }
      if (tableName == 'tasksDone') {
        database.transaction((txn) async {
          await txn.delete('tasksDone', where: 'title = ?', whereArgs: [task.title]);
          await txn.insert('tasks', {'title': task.title, 'isDone': 0});
        });
      }
    }catch(exception){print('Error toggling taskdone status: $exception');}
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
      String oldTitle, String newTitle, bool? isDone) async {
    final database = await DatabaseService.openDb();
    final data = {'title': newTitle, 'isDone': isDone == true ? 1 : 0};
    final result = await database
        .update('tasks', data, where: 'title = ?', whereArgs: [oldTitle]);
    print(result);
    print(newTitle);
    return result;
  }

  static Future<void> deleteTask(
      {required String title, required String tableName}) async {
    final database = await DatabaseService.openDb();
    try {
      await database.delete(tableName, where: 'title = ?', whereArgs: [title]);
    } catch (exception) {
      debugPrint('Something went wrong when deleting the task: $exception');
    }
  }
}
