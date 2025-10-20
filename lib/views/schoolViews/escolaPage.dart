import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muto_system/configs/colors.dart' as ThemeColors;

const String baseUrl =
    "http://127.0.0.1:5000/api"; // use 10.0.2.2 no emulador Android

class EscolaPage extends StatefulWidget {
  const EscolaPage({super.key});

  @override
  State<EscolaPage> createState() => _EscolaPageState();
}

class _EscolaPageState extends State<EscolaPage> {
  List escolas = [];
  bool loading = false;
  final TextEditingController nomeEscolaController = TextEditingController();

  // =============================
  // Função: Buscar escolas
  // =============================
  Future<void> listarEscolas() async {
    setState(() => loading = true);
    try {
      final response = await http.get(Uri.parse('$baseUrl/escolas'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          escolas = data['escolas'] ?? [];
        });
      } else {
        debugPrint("Erro ao buscar escolas: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Erro: $e");
    }
    setState(() => loading = false);
  }

  // =============================
  // Função: Criar escola
  // =============================
  Future<void> criarEscola() async {
    final nome = nomeEscolaController.text.trim();
    if (nome.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Digite o nome da escola")));
      return;
    }

    setState(() => loading = true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/escola/criar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nome': nome}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Escola criada com sucesso!")),
        );
        nomeEscolaController.clear();
        listarEscolas();
      } else {
        final msg =
            jsonDecode(response.body)['message'] ?? "Erro ao criar escola";
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      debugPrint("Erro: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Falha de conexão")));
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    listarEscolas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.Colors.background_black,
      appBar: AppBar(
        title: const Text("Gerenciar Escolas"),
        backgroundColor: ThemeColors.Colors.background_black,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : RefreshIndicator(
              onRefresh: listarEscolas,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Campo de criação
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: nomeEscolaController,
                          decoration: const InputDecoration(
                            labelText: "Nome da escola",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                ThemeColors.Colors.background_black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: criarEscola,
                          child: const Text("Criar nova escola"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Lista de escolas
                  ...escolas.map(
                    (e) => Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                        title: Text(
                          e['nick'] ?? 'Sem nome',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              "Código Professor: ${e['teachercode'] ?? '-'}",
                            ),
                            Text("Código Aluno: ${e['studentcode'] ?? '-'}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
