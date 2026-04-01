import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/util/storage_service.dart';

class ProfileService {
  static const String baseUrl = "https://mathapi.dsrt321.online";

  // Token helper
  final String? token = StorageService.accessToken;

  // ===========================
  /// GET PROFILE
  // ===========================
  Future<Map<String, dynamic>> getProfile() async {



    final url = Uri.parse("$baseUrl/api/users/profile/");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    return {
      "status": response.statusCode,
      "data": data,
    };
  }

  // ===========================
  /// UPDATE PROFILE (email)
  // ===========================
  Future<Map<String, dynamic>> updateProfile({
    required String email,
  }) async {
    final url = Uri.parse("$baseUrl/api/users/profile/");

    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "email": email,
      }),
    );

    final data = jsonDecode(response.body);

    return {
      "status": response.statusCode,
      "data": data,
    };
  }

  // ===========================
  /// DELETE PROFILE
  // ===========================
  Future<Map<String, dynamic>> deleteProfile() async {
    final url = Uri.parse("$baseUrl/api/users/profile/");

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return {
      "status": response.statusCode,
      "data": response.body.isNotEmpty ? jsonDecode(response.body) : {},
    };
  }

  // ===========================
  /// LOGOUT
  // ===========================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }
}