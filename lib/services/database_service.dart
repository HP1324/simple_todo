import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService instance = DatabaseService._internal();
  static Future<void> createTables(Database database) async {
    await database.execute(""" CREATE TABLE categories(
      categoryId INTEGER PRIMARY KEY AUTOINCREMENT,
      categoryName TEXT UNIQUE
      )
     """);
    await database.execute("""CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      isDone INTEGER DEFAULT 0,
      categoryId INTEGER DEFAULT 1,
      FOREIGN KEY(categoryId) REFERENCES categories (categoryId)
        ON DELETE SET DEFAULT
      )""");

    await database.execute(
        """INSERT INTO categories (categoryName) VALUES('Self improvement'),('Family'),('Work')""");

  }

  static Future<Database> openDb() async {
    return openDatabase('simple_todo.db', version: 1,
        onCreate: (database, version) async {
      await createTables(database);
    });
  }
}
