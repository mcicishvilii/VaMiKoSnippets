import 'package:flutter/material.dart';

class CustomPopupMenu extends StatelessWidget {
  final VoidCallback hideUserMenu;
  final VoidCallback logOut;

  const CustomPopupMenu({
    super.key,
    required this.hideUserMenu,
    required this.logOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            onTap: () {
              hideUserMenu(); // Use the passed function
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Edit Profile tapped!")),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Account Settings'),
            onTap: () {
              hideUserMenu(); // Use the passed function
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Account settings tapped!"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              hideUserMenu();
              logOut();
            },
          ),
        ],
      ),
    );
  }
}
