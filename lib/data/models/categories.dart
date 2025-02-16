import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories
        .add(CategoryModel(name: 'Web Design', boxColor: Color(0xff9DCEFF)));

    categories
        .add(CategoryModel(name: 'Development', boxColor: Color(0xffEEA4CE)));

    categories.add(
        CategoryModel(name: 'Graphic Design', boxColor: Color(0xff9DCEFF)));

    categories
        .add(CategoryModel(name: 'Marketing', boxColor: Color(0xffEEA4CE)));

    categories.add(CategoryModel(name: 'Finance', boxColor: Color(0xffEEA4CE)));
    return categories;
  }
}
