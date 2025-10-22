import 'package:flutter/material.dart';
import 'package:muto_system/views/userViews/userProfileView.dart';

// Exemplo de páginas simuladas (substitua pelos seus arquivos reais)
class LigaView extends StatelessWidget {
  const LigaView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Liga de Amigos'));
  }
}

class ProgressoView extends StatelessWidget {
  const ProgressoView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Progresso'));
  }
}

class CampeonatosView extends StatelessWidget {
  const CampeonatosView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Campeonatos'));
  }
}

class ConquistasView extends StatelessWidget {
  const ConquistasView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Conquistas'));
  }
}

// ----------------------------------------
// HOME VIEW (com barra de navegação)
// ----------------------------------------
class HomeView extends StatefulWidget {
  final String token;
  const HomeView({super.key, required this.token});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 2; // Começa na aba do meio (perfil)

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ProgressoView(),
      const LigaView(),
      UserProfileView(token: widget.token),
      const ConquistasView(),
      const CampeonatosView(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: const Color(0xFF141414),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Progresso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: 'Liga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            label: 'Conquistas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.military_tech_outlined),
            label: 'Competições',
          ),
        ],
      ),
    );
  }
}
