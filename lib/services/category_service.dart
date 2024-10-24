import 'package:planner/models/category.dart';
import 'package:planner/services/database_service.dart';

class CategoryService {
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final database = await DatabaseService.openDb();
    return await database.query('categories');
  }

  static Future<void> addCategory({required CategoryModel category}) async {
    final database = await DatabaseService.openDb();
    database.insert('categories', category.toJson());
  }

  static Future<void> deleteCategory({required int id}) async {
    final database = await DatabaseService.openDb();
    database.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}
