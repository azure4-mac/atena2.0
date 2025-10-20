import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "http://127.0.0.1:5000/api";

class SchoolConnection {
  // ============================================================
  // CRIAR ESCOLA (professor)
  // ============================================================
  static Future<Map<String, dynamic>> createSchool(
    String token,
    String nome,
    String codEntrada,
  ) async {
    final url = Uri.parse('$baseUrl/escola');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'nome': nome, 'cod_entrada': codEntrada}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {'success': true, 'escola': data['escola']};
    } else {
      final data = jsonDecode(response.body);
      return {
        'success': false,
        'message': data['erro'] ?? 'Erro ao criar escola',
      };
    }
  }

  // ============================================================
  // ENTRAR NA ESCOLA (aluno via código)
  // ============================================================
  static Future<Map<String, dynamic>> joinSchool(
    String token,
    String codEntrada,
  ) async {
    final url = Uri.parse('$baseUrl/escola/join');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'cod_entrada': codEntrada}),
    );

    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200,
      'message': data['message'] ?? data['erro'] ?? 'Erro ao entrar na escola',
    };
  }

  // ============================================================
  // BUSCAR DETALHES DA ESCOLA (professores + alunos)
  // ============================================================
  static Future<Map<String, dynamic>> getEscola(
    String token,
    int escolaId,
  ) async {
    final url = Uri.parse('$baseUrl/escola/$escolaId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      final data = jsonDecode(response.body);
      return {
        'success': false,
        'message': data['erro'] ?? 'Erro ao carregar escola',
      };
    }
  }
}
