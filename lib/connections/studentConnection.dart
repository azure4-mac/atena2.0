import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiConnection {
  // Ajuste para o IP/host onde sua API Flask está rodando
  static const String baseUrl = 'http://127.0.0.1:5000'; // emulador android

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Map<String, String> jsonHeaders([String? token]) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  static Future<http.Response> post(String path, Map body, {String? token}) {
    return http.post(
      Uri.parse('$baseUrl$path'),
      headers: jsonHeaders(token),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> get(String path, {String? token}) async {
    return http.get(Uri.parse('$baseUrl$path'), headers: jsonHeaders(token));
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
