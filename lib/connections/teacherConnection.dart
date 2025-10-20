import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "http://127.0.0.1:5000/api";

class TeacherConnection {
  static Future<Map<String, dynamic>> createCampeonato(
    String token,
    String nome,
  ) async {
    final url = Uri.parse('$baseUrl/campeonato');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'nome': nome}),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {'success': false, 'message': 'Erro ao criar campeonato'};
    }
  }

  static Future<Map<String, dynamic>> createLiga(
    String token,
    String nome,
  ) async {
    final url = Uri.parse('$baseUrl/ligas');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'nome': nome}),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {'success': false, 'message': 'Erro ao criar liga'};
    }
  }

  static Future<Map<String, dynamic>> createQuestao(
    String token,
    String materia,
    String texto,
  ) async {
    final url = Uri.parse('$baseUrl/questao');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'materia': materia, 'texto': texto}),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {'success': false, 'message': 'Erro ao criar questão'};
    }
  }
}
