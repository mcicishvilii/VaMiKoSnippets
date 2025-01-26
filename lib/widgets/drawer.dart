import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          title: const Text('About Us'),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("About Us tapped!")),
            );
          },
        ),
        const Divider(),
        ListTile(
          title: const Text('Contact'),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Contact tapped!")),
            );
          },
        ),
        const Divider(),
        ListTile(
          title: const Text('Terms of Service'),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Terms of Service tapped!")),
            );
          },
        ),
        const Divider(),
        ListTile(
          title: const Text('Privacy Policy'),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Privacy Policy tapped!")),
            );
          },
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Search...',
            ),
            onChanged: (value) {
              // Implement search functionality
            },
          ),
        ),
      ],
    );
  }
}
