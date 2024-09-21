
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Future<void> createTable(Database database)async{
    await database.execute("""CREATE TABLE tasks(
      title text,
      isDone int
      )""");
  }

  static Future<Database> openDb()async{
    return openDatabase(
      'simple_todo.db',
      version: 1,
      onCreate: (database,version)async{
        await createTable(database);
      }
    );
  }

  static Future<int> createTask(String? title, bool? isDone)async{
    final database = await DatabaseService.openDb();
    final data = {'title' : title, 'isDone' : isDone};
    final id = await database.insert('tasks', data, conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String,dynamic>>> getTask() async{
    final database = await DatabaseService.openDb();
    return database.query('tasks');
  }

  static Future<int> updateTask(String? title, bool? isDone) async{
      final database = await DatabaseService.openDb();

      final data = {'title' : title, 'isDone': isDone};
      final result = await database.update('tasks',data, where: 'title = ?',whereArgs: [title]);
      return result;
  }
  static Future<void> deleteItem(String title)async{
    final database = await DatabaseService.openDb();
    try{
      await database.delete('tasks',where: 'title = ?',whereArgs: [title]);
    } catch(exception){
      debugPrint('Something went wrong when deleting the task: $exception');
    }
  }
}