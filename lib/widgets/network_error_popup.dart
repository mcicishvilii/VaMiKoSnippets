import 'package:flutter/material.dart';

class NetworkErrorPopup extends StatelessWidget {
  final String? error;
  final VoidCallback loadProfile;
  const NetworkErrorPopup({
    super.key,
    required this.error,
    required this.loadProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error!,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: loadProfile,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
