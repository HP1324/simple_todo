import 'package:flutter/material.dart';
import 'package:planner/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      categoryId INTEGER,
      isDone INTEGER DEFAULT 0,
      FOREIGN KEY(categoryId) REFERENCES categories (categoryId)
      )""");
    await database.execute(""" CREATE TABLE categories(
      categoryId INTEGER PRIMARY KEY AUTOINCREMENT,
      categoryName TEXT UNIQUE
      )
     """);
    await database.execute("""INSERT INTO categories (categoryName) VALUES('Self improvement'),('Family'),('Work')""");
  }

  static Future<Database> openDb() async {
    return openDatabase('simple_todo.db', version: 1,
        onCreate: (database, version) async {
      await createTables(database);
    });
  }
}
