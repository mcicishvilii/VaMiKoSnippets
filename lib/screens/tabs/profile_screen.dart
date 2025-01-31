import 'package:flutmisho/models/user_profile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final UserProfile? userProfile;

  const ProfileScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.green,
        leadingWidth: 80,
        titleSpacing: 0, // Ensures title starts from the beginning
        title: Row(
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Queen_Elizabeth_II_official_portrait_for_1959_tour_%28retouched%29_%28cropped%29_%283-to-4_aspect_ratio%29.jpg/220px-Queen_Elizabeth_II_official_portrait_for_1959_tour_%28retouched%29_%28cropped%29_%283-to-4_aspect_ratio%29.jpg',
                ),
              ),
            ),
            const SizedBox(width: 10), // Space between avatar and text
            Expanded(
              child: Text(
                userProfile?.email ?? 'John Doe',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow:
                    TextOverflow.ellipsis, // Ensures text doesn't overflow
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Profile Screen Content'),
      ),
    );
  }
}
