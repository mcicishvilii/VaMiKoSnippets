import 'package:flutter/material.dart';
import 'package:flutmisho/models/categories.dart';

class TopicCategories extends StatefulWidget {
  const TopicCategories({super.key});

  @override
  TopicCategoriesState createState() => TopicCategoriesState();
}

class TopicCategoriesState extends State<TopicCategories> {
  final List<CategoryModel> categories = CategoryModel.getCategories();
  int? selectedIndex; // To keep track of the selected chip index

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Categories",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
