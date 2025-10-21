import 'package:flutter/material.dart';
import 'package:muto_system/connections/studentConnection.dart';
import 'package:muto_system/configs/colors.dart' as ThemeColors;

class UserProfileView extends StatefulWidget {
  final String token;
  const UserProfileView({Key? key, required this.token}) : super(key: key);
  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
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
        errorMsg = result['message'] ?? 'Erro ao carregar perfil';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    if (errorMsg != null) {
      return Scaffold(
        backgroundColor: ThemeColors.Colors.background_black,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text("Perfil"),
        ),
        body: Center(
          child: Text(
            errorMsg!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }
    final email = user?['email'] ?? '—';
    final nivel = user?['nivel']?.toString() ?? '1';
    final ofensiva = user?['ofensiva']?.toString() ?? '—';
    final escola = user?['escola']?['nick'] ?? 'Sem escola';

    return Scaffold(
      backgroundColor: ThemeColors.Colors.background_black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Meu Perfil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/example.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage('assets/img/example.png'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            Text(
              email,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  escola,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C4E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatusInfo(title: 'Ofensiva', value: ofensiva),
                      _StatusInfo(title: 'Nível', value: nivel),
                      _StatusInfo(title: 'Escola', value: escola),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Conquistas em Destaque',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.military_tech, color: Colors.grey, size: 40),
                      Icon(Icons.emoji_events, color: Colors.orange, size: 40),
                      Icon(Icons.star, color: Colors.yellow, size: 40),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C4E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/conquistas');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Todas as Conquistas'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Filtrar por Matéria: ',
                        style: TextStyle(color: Colors.white),
                      ),
                      DropdownButton<String>(
                        dropdownColor: Colors.black,
                        value: 'Matemática',
                        style: const TextStyle(color: Colors.white),
                        items: const [
                          DropdownMenuItem(
                            value: 'Matemática',
                            child: Text('Matemática'),
                          ),
                          DropdownMenuItem(
                            value: 'História',
                            child: Text('História'),
                          ),
                          DropdownMenuItem(
                            value: 'Química',
                            child: Text('Química'),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _StatusInfo extends StatelessWidget {
  final String title;
  final String value;
  const _StatusInfo({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
