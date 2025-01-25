import 'package:flutter/material.dart';

class TopAppBarExample extends StatelessWidget {
  const TopAppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Change the color as needed
        title: Row(
          children: [
            // App logo on the left
            Image.asset(
              'assets/flutter_logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              "My App",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Profile icon
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle profile icon tap
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile tapped')),
              );
            },
          ),

          // Burger menu
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Handle menu tap
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu tapped')),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("App Content Goes Here"),
      ),
    );
  }
}
