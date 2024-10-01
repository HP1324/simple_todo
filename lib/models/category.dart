// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  final int? caetgoryId;
  final String categoryName;

  const CategoryModel({
    this.caetgoryId,
    required this.categoryName,
  });

  CategoryModel copyWith({
    int? caetgoryId,
    String? categoryName,
  }) =>
      CategoryModel(
        caetgoryId: caetgoryId ?? this.caetgoryId,
        categoryName: categoryName ?? this.categoryName,
      );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    caetgoryId: json["caetgoryId"],
    categoryName: json["categoryName"],
  );

  Map<String, dynamic> toJson() => {
    "caetgoryId": caetgoryId,
    "categoryName": categoryName,
  };
}
