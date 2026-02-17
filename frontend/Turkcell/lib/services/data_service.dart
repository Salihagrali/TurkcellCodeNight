import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_response_model.dart';
import '../models/show_model.dart';
import '../models/leaderboard_model.dart';

class DataService {
  // ⚠️ CRITICAL: Use your ngrok URL, NOT localhost!
  // Your ngrok URL (from your message):
  final String baseUrl = 'https://awnless-majorie-unspending.ngrok-free.dev';

  // ============================================
  // DASHBOARD API
  // ============================================

  /// Get full dashboard for a user
  /// Endpoint: GET /api/v1/dashboard/users/{userId}
  Future<DashboardResponse> getFullDashboard(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/dashboard/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true', // For ngrok
        },
      );

      print('Dashboard API Response: ${response.statusCode}');
      print('Dashboard API Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return DashboardResponse.fromJson(jsonData);
      } else {
        throw Exception('Dashboard yüklenemedi: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Dashboard API Error: $e');
      throw Exception('Dashboard hatası: $e');
    }
  }

  // ============================================
  // CATALOG API
  // ============================================

  /// Get show catalog with episodes
  /// Endpoint: GET /api/catalog/shows-with-episodes
  Future<List<ShowModel>> getCatalog() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/catalog/shows-with-episodes'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true', // For ngrok
        },
      );

      print('Catalog API Response: ${response.statusCode}');
      print('Catalog API Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => ShowModel.fromJson(json)).toList();
      } else {
        throw Exception('Katalog yüklenemedi: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Catalog API Error: $e');
      throw Exception('Katalog hatası: $e');
    }
  }

  // ============================================
  // WATCH ACTIVITY API
  // ============================================

  /// Report watch activity
  /// Endpoint: POST /api/activity/watch
  /// 
  /// Backend requires: { userId, episodeId, eventDate, rating }
  /// rating is REQUIRED by backend (defaults to 5 if not provided)
  Future<bool> reportWatchActivity(
    String userId,
    String episodeId, {
    int? rating,
  }) async {
    try {
      // Format date as YYYY-MM-DD
      final now = DateTime.now();
      final eventDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      
      // Backend REQUIRES rating field, default to 5
      final body = {
        'userId': userId,
        'episodeId': episodeId,
        'eventDate': eventDate,
        'rating': rating ?? 5, // ALWAYS include rating, default to 5
      };

      print('Watch Activity Request: $body');

      final response = await http.post(
        Uri.parse('$baseUrl/api/activity/watch'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: json.encode(body),
      );

      print('Watch Activity Response: ${response.statusCode}');
      print('Watch Activity Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Watch activity failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Watch Activity Error: $e');
      return false;
    }
  }

  // ============================================
  // LEADERBOARD API
  // ============================================

  /// Get leaderboard
  /// Endpoint: GET /api/leaderboard (or /api/v1/leaderboard)
  /// 
  /// ⚠️ If you get 404, try changing to /api/v1/leaderboard
  Future<List<LeaderboardUser>> getLeaderboard() async {
    try {
      // Try /api/leaderboard first
      var response = await http.get(
        Uri.parse('$baseUrl/api/leaderboard'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      // If 404, try /api/v1/leaderboard
      if (response.statusCode == 404) {
        print('Trying alternative endpoint: /api/v1/leaderboard');
        response = await http.get(
          Uri.parse('$baseUrl/api/v1/leaderboard'),
          headers: {
            'Content-Type': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
        );
      }

      print('Leaderboard API Response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        print('Leaderboard API Body: ${response.body}');
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => LeaderboardUser.fromJson(json)).toList();
      } else {
        print('Leaderboard API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Liderlik tablosu yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      print('Leaderboard API Error: $e');
      throw Exception('Liderlik hatası: $e');
    }
  }

  // ============================================
  // USER LIST API (for login/selection)
  // ============================================

  /// Get list of users
  /// Endpoint: GET /api/v1/dashboard/users
  Future<List<Map<String, dynamic>>> getUserList() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/dashboard/users'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      print('User List API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonData);
      } else {
        throw Exception('Kullanıcı listesi yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      print('User List API Error: $e');
      throw Exception('Kullanıcı listesi hatası: $e');
    }
  }
}