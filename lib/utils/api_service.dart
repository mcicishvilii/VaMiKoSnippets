import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login/login_request.dart';
import '../models/login/login_response.dart';
import '../models/user.dart';
import '../models/user_profile.dart';

class ApiService {
  static const String baseUrl = 'https://ladogudi.serv00.net/api';

  Future<Map<String, dynamic>> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  Future<Map<String, dynamic>> login(LoginRequest loginRequest) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginRequest.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(data);
        // Here you might want to store tokens in secure storage
        return {
          'success': true,
          'message': loginResponse.message,
          'access_token': loginResponse.accessToken,
          'refresh_token': loginResponse.refreshToken,
        };
      } else {
        return {'success': false, 'message': data['error'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final profile = UserProfile.fromJson(data);
        return {
          'success': true,
          'profile': profile,
        };
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Failed to load profile'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  Future<Map<String, dynamic>> logout(
      String accessToken, String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Logout failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }
}
