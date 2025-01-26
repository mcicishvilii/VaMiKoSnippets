import 'package:flutter/material.dart';

class TextFieldWithIcons extends StatelessWidget {
  const TextFieldWithIcons({
    super.key,
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
        decoration: InputDecoration(
          filled: true,
          hintText: "Search",
          fillColor: Colors.grey[150],
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              // _searchController.clear();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
