import 'package:flutter/material.dart';
import '../../connections/teacherConnection.dart';

class CriarLigaView extends StatefulWidget {
  final String token;
  const CriarLigaView({super.key, required this.token});

  @override
  State<CriarLigaView> createState() => _CriarLigaViewState();
}

class _CriarLigaViewState extends State<CriarLigaView> {
  final _nomeController = TextEditingController();
  bool _loading = false;

  Future<void> _criarLiga() async {
    setState(() => _loading = true);
    final result = await TeacherConnection.createLiga(
      widget.token,
      _nomeController.text.trim(),
    );
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? "Liga criada com sucesso!" : result['message'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar Liga')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome da Liga'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _criarLiga,
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
