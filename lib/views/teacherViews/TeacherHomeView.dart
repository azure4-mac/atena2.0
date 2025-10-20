import 'package:flutter/material.dart';
import 'criarCampeonatoView.dart';
import 'criarLigaView.dart';
import 'criarQuestaoView.dart';

class TeacherHomeView extends StatelessWidget {
  final String token;
  const TeacherHomeView({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Área do Professor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CriarCampeonatoView(token: token),
                ),
              ),
              child: Text('Criar Campeonato'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CriarLigaView(token: token)),
              ),
              child: Text('Criar Liga'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CriarQuestaoView(token: token),
                ),
              ),
              child: Text('Criar Questão'),
            ),
          ],
        ),
      ),
    );
  }
}
