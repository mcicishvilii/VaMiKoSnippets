import 'package:flutter/material.dart';

class UserProfileModal extends StatelessWidget {
  final String email;
  final VoidCallback onClose;
  final VoidCallback onLogout;

  const UserProfileModal({
    super.key,
    required this.email,
    required this.onClose,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Colors.black.withAlpha(40), // Dim background
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300, // Fixed width for alert-like feel
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: onClose,
                        icon: Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  const SizedBox(height: 16),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: onLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Log Out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
