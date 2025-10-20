import 'package:flutter/material.dart';
import '../../connections/teacherConnection.dart';

class CriarQuestaoView extends StatefulWidget {
  final String token;
  const CriarQuestaoView({super.key, required this.token});

  @override
  State<CriarQuestaoView> createState() => _CriarQuestaoViewState();
}

class _CriarQuestaoViewState extends State<CriarQuestaoView> {
  final _materiaController = TextEditingController();
  final _textoController = TextEditingController();
  bool _loading = false;

  Future<void> _criarQuestao() async {
    setState(() => _loading = true);
    final result = await TeacherConnection.createQuestao(
      widget.token,
      _materiaController.text.trim(),
      _textoController.text.trim(),
    );
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? "Questão criada com sucesso!" : result['message'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar Questão')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _materiaController,
              decoration: InputDecoration(labelText: 'Matéria'),
            ),
            TextField(
              controller: _textoController,
              decoration: InputDecoration(labelText: 'Texto'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _criarQuestao,
              child: _loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Criar'),
            ),
          ],
        ),
      ),
    );
  }
}
