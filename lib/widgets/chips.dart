import 'package:flutter/material.dart';
import 'package:flutmisho/models/categories.dart';

class TopicChips extends StatefulWidget {
  final Function(String?) onCategorySelected;

  TopicChips({super.key, required this.onCategorySelected});

  @override
  _TopicChipsState createState() => _TopicChipsState();
}

class _TopicChipsState extends State<TopicChips> {
  final List<CategoryModel> categories = CategoryModel.getCategories();
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color.fromARGB(255, 197, 226, 255),
      ),
      margin: EdgeInsets.only(left: 16, right: 16),
      padding: EdgeInsets.only(top: 28, bottom: 28, left: 8, right: 8),
      child: Wrap(
        spacing: 4.0,
        runSpacing: 8.0,
        children: categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;

          return GestureDetector(
            onTap: () {
              setState(() {
                if (selectedIndex == index) {
                  selectedIndex = null;
                } else {
                  selectedIndex = index;
                }
              });
              widget.onCategorySelected(
                selectedIndex == null ? null : category.name,
              );
            },
            child: Chip(
              shape: StadiumBorder(
                side: BorderSide(
                  color: selectedIndex == index
                      ? Color.fromARGB(255, 197, 226, 255)
                      : Color.fromARGB(255, 197, 226, 255),
                ),
              ),
              label: Text(
                category.name,
                style: TextStyle(
                  color: selectedIndex == index ? Colors.white : Colors.black,
                ),
              ),
              backgroundColor: selectedIndex == index
                  ? Colors.blue
                  : Color.fromARGB(255, 197, 226, 255),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          );
        }).toList(),
      ),
    );
  }
}
