import 'package:flutter/material.dart';
import '../connections/dataLoaderConnection.dart';

class PageTest extends StatefulWidget {
  @override
  State<PageTest> createState() => _PageTestState();
}

class _PageTestState extends State<PageTest> {
  String? nome;

  @override
  void initState() {
    super.initState();
    carregarNome();
  }

  void carregarNome() async {
    final resultado = UserBasicDataLoader();
    setState(() {
      nome = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: Text('Resultado')),
      body: Center(
        child: nome == null
            ? CircularProgressIndicator()
            : Text(
                nome!,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
