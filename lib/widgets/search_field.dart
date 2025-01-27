import 'package:flutter/material.dart';

class TextFieldWithIcons extends StatelessWidget {
  final Function(String) onSearchChanged;
  final TextEditingController searchController;

  const TextFieldWithIcons({
    super.key,
    required this.onSearchChanged,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 189, 2, 2).withAlpha(11),
          blurRadius: 40,
          spreadRadius: 0.0,
        ),
      ]),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          filled: true,
          hintText: "Search",
          fillColor: Colors.grey[150],
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              onSearchChanged(''); // Clear the search filter
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}
