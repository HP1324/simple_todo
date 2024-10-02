import 'package:flutter/material.dart';
import 'package:planner/models/category.dart';
import 'package:planner/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider() {
    _refreshCategories();
  }
  List<Map<String, dynamic>> categories = [];
  var selectedCategory = 0;
  void _refreshCategories() async {
    debugPrint('|||||||||| Inside refresh categories |||||||||||');
    categories = await CategoryService.getCategories();
    debugPrint('all categories: ${categories.toString()}');
    notifyListeners();
    debugPrint('|||||||||| End of refresh categories |||||||||||');
  }

  Future<bool> addCategory({required String categoryName}) async {
    if (categoryName.trim().isNotEmpty) {
      CategoryModel categoryObj = CategoryModel(categoryName: categoryName);
      await CategoryService.addCategory(category: categoryObj);
      selectedCategory = categoryObj.categoryId!;
      _refreshCategories();
      return true;
    }
    return false;
  }
}
