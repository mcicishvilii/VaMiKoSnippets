import 'package:flutmisho/models/user_profile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final UserProfile? userProfile;

  const ProfileScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Profile Screen'),
          if (userProfile != null) Text('Welcome ${userProfile!.email}'),
        ],
      ),
    );
  }
}
