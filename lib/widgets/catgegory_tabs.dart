import 'package:flutter/material.dart';
import 'package:flutmisho/data/models/categories.dart';

class TopicTabs extends StatefulWidget {
  final Function(String?) onCategorySelected;

  const TopicTabs({super.key, required this.onCategorySelected});

  @override
  TopicTabsState createState() => TopicTabsState();
}

class TopicTabsState extends State<TopicTabs> {
  final List<CategoryModel> categories = CategoryModel.getCategories();
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selectedIndex == index
                        ? Colors.blue
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                category.name,
                style: TextStyle(
                  color:
                      selectedIndex == index ? Colors.blue : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
