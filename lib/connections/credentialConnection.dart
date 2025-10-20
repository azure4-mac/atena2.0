import 'dart:convert';
import 'package:http/http.dart' as http;

// se estiver testando no emulador Android use 10.0.2.2
const String baseUrl = "http://127.0.0.1:5000/api";

class CredentialConnection {
  // ---------- LOGIN ----------
  static Future<Map<String, dynamic>> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'token': data['token'],
        'user': data['user_data'],
        'type': data['user_type'],
      };
    } else {
      return {
        'success': false,
        'message': jsonDecode(response.body)['message'] ?? 'Falha no login',
      };
    }
  }

  // ---------- REGISTRO ----------
  static Future<Map<String, dynamic>> register(
    String email,
    String senha,
    String nick,
    String schoolCode,
  ) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'senha': senha,
        'nick': nick,
        'school_code': schoolCode, // <- novo campo
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'message': data['message'] ?? 'Usuário criado com sucesso!',
        'user': data['user'],
        'role': data['role'] ?? data['user_type'], // se o backend enviar isso
      };
    } else {
      return {
        'success': false,
        'message': jsonDecode(response.body)['message'] ?? 'Falha no cadastro',
      };
    }
  }
}
