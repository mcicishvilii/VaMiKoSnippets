import 'package:flutmisho/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_page.dart';
import 'screens/login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Map<String, String?>> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn && accessToken != null && refreshToken != null) {
      return {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
    }
    return {
      'accessToken': null,
      'refreshToken': null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final tokens = snapshot.data;
        final isLoggedIn = tokens?['accessToken'] != null;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: isLoggedIn
              ? HomePage(
                  accessToken: tokens!['accessToken']!,
                  refreshToken: tokens['refreshToken']!,
                )
              : const LoginPage(),
        );
      },
    );
  }
}
