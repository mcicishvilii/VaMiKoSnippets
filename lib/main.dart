import 'package:device_preview/device_preview.dart';
import 'package:flutmisho/domain/usecase/items_use_case.dart';
import 'package:flutmisho/ui/viewmodel/all_items_view_model.dart';
import 'package:flutmisho/utils/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/screens/tabs/home_page.dart';
import 'ui/screens/login/login_page.dart';
import 'styles/theme.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() {
  setup();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ChangeNotifierProvider(
        create: (context) => MishoViewModel(useCase: sl<MishoUseCaseAll>()),
        child: MyApp(),
      ),
    ),
  );
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
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final tokens = snapshot.data;
        final isLoggedIn = tokens?['accessToken'] != null;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
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
