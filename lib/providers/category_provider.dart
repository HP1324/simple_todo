import 'package:flutter/material.dart';
import 'package:planner/models/category.dart';
import 'package:planner/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> categories = [];
  var categoryController = TextEditingController();
  void _refershCategories() async {
    categories = await CategoryService.getCaegories();
  }

  Future<bool> addCategory({required String categoryName}) async {
    if (categoryName.trim().isNotEmpty) {
      CategoryModel categoryObj = CategoryModel(categoryName: categoryName);
      await CategoryService.addCategory(category: categoryObj);
      notifyListeners();
      return true;
    }
    return false;
  }
}
