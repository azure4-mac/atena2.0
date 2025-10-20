import 'package:flutter/material.dart';
import 'package:muto_system/connections/studentConnection.dart';

class UserHomeView extends StatefulWidget {
  final String token;

  const UserHomeView({Key? key, required this.token}) : super(key: key);

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  Map<String, dynamic>? user;
  bool loading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      loading = true;
      errorMsg = null;
    });

    final result = await StudentConnection.getProfile(widget.token);
    if (result['success']) {
      setState(() {
        user = result['data'];
        loading = false;
      });
    } else {
      setState(() {
        errorMsg = result['message'] ?? 'Erro desconhecido';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMsg != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Painel do Aluno'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: Text(errorMsg!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Aluno'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Bem-vindo, ${user?['nick'] ?? "Usuário"}!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Email: ${user?['email'] ?? "—"}'),
            Text('Nível: ${user?['nivel'] ?? "—"}'),
            Text('Ofensiva: ${user?['ofensiva'] ?? "—"}'),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // Navegação
            _menuButton(
              title: 'Minhas Escolas',
              icon: Icons.school,
              onTap: () => Navigator.pushNamed(context, '/escolas'),
            ),
            _menuButton(
              title: 'Campeonatos',
              icon: Icons.emoji_events,
              onTap: () => Navigator.pushNamed(context, '/campeonatos'),
            ),
            _menuButton(
              title: 'Ligas',
              icon: Icons.people,
              onTap: () => Navigator.pushNamed(context, '/ligas'),
            ),
            _menuButton(
              title: 'Questões',
              icon: Icons.question_answer,
              onTap: () => Navigator.pushNamed(context, '/questoes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
