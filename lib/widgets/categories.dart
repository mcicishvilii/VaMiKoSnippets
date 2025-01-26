import 'package:flutmisho/models/user_profile.dart';
import 'package:flutter/material.dart';

class TopicCategories extends StatelessWidget {
  // final VoidCallback hideUserMenu;
  // final VoidCallback logOut;
  // final UserProfile? userProfile;

  const TopicCategories({
    super.key,
    // required this.hideUserMenu,
    // required this.logOut,
    // required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Category",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
