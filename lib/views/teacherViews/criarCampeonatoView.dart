import 'package:flutter/material.dart';
import '../../connections/teacherConnection.dart';

class CriarCampeonatoView extends StatefulWidget {
  final String token;
  const CriarCampeonatoView({super.key, required this.token});

  @override
  State<CriarCampeonatoView> createState() => _CriarCampeonatoViewState();
}

class _CriarCampeonatoViewState extends State<CriarCampeonatoView> {
  final _nomeController = TextEditingController();
  bool _loading = false;

  Future<void> _criarCampeonato() async {
    setState(() => _loading = true);
    final result = await TeacherConnection.createCampeonato(
      widget.token,
      _nomeController.text.trim(),
    );
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success']
              ? "Campeonato criado com sucesso!"
              : result['message'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar Campeonato')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome do Campeonato'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _criarCampeonato,
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
