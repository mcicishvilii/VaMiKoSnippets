import 'dart:convert';
import 'package:flutmisho/utils/token_manager.dart';
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
      final response = await _authenticatedRequest('GET', 'profile', token);
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

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'access_token': data['access_token'],
        };
      } else {
        return {'success': false, 'message': data['error'] ?? 'Refresh failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  // Create a wrapper for authenticated requests
  Future<http.Response> _authenticatedRequest(
    String method,
    String endpoint,
    String accessToken, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    late http.Response response;

    if (method == 'GET') {
      response = await http.get(uri, headers: headers);
    } else if (method == 'POST') {
      response = await http.post(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
    } else {
      throw Exception('Unsupported HTTP method');
    }

    // If token is expired, try to refresh
    if (response.statusCode == 401) {
      final tokens = await TokenManager.getTokens();
      final refreshToken = tokens['refreshToken'];

      if (refreshToken != null) {
        final refreshResult = await this.refreshToken(refreshToken);

        if (refreshResult['success']) {
          // Save new access token
          await TokenManager.saveTokens(
            accessToken: refreshResult['access_token'],
            refreshToken: refreshToken,
          );

          // Retry the original request with new token
          headers['Authorization'] = 'Bearer ${refreshResult['access_token']}';

          if (method == 'GET') {
            return await http.get(uri, headers: headers);
          } else {
            return await http.post(
              uri,
              headers: headers,
              body: body != null ? jsonEncode(body) : null,
            );
          }
        }
      }
    }

    return response;
  }
}
