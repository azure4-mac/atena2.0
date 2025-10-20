import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:muto_system/connections/credentialConnection.dart';
import 'package:muto_system/views/credentialViews/loginView.dart';
import 'package:muto_system/configs/colors.dart' as ThemeColors;

class CredentialView extends StatefulWidget {
  const CredentialView({super.key});

  @override
  State<CredentialView> createState() => _CredentialViewState();
}

class _CredentialViewState extends State<CredentialView> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController schoolName = TextEditingController();
  final TextEditingController schoolCodeController = TextEditingController();

  void showSnack(String message, bool success) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: success ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ThemeColors.Colors.background_black,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/img/logoAtena.png", width: 175),

                  const SizedBox(height: 16),

                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: "NOME",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: "EMAIL",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "SENHA",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: schoolName,
                    decoration: InputDecoration(
                      labelText: "NOME DA ESCOLA (opcional)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: schoolCodeController,
                    decoration: InputDecoration(
                      labelText: 'Código da escola',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---------- BOTÃO DE CADASTRO ----------
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.Colors.background_black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        try {
                          if (email.text.isEmpty ||
                              password.text.isEmpty ||
                              name.text.isEmpty ||
                              schoolCodeController.text.isEmpty) {
                            showSnack(
                              'Preencha todos os campos obrigatórios!',
                              false,
                            );
                            return;
                          }

                          final result = await CredentialConnection.register(
                            email.text,
                            password.text,
                            name.text,
                            schoolCodeController.text,
                          );

                          if (result['success']) {
                            final role = result['role'] ?? 'usuário';
                            showSnack('Cadastro realizado como $role!', true);

                            // Redirecionamento condicional
                            await Future.delayed(
                              const Duration(seconds: 1),
                            ); // tempo pra ver o snackbar

                            if (role == 'teacher') {
                              Navigator.pushReplacementNamed(
                                context,
                                '/teacherHome',
                              );
                            } else if (role == 'student') {
                              Navigator.pushReplacementNamed(
                                context,
                                '/studentHome',
                              );
                            } else {
                              // fallback para login se não tiver role
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CredentialViewLogin(),
                                ),
                              );
                            }
                          } else {
                            showSnack(
                              result['message'] ?? 'Erro ao cadastrar',
                              false,
                            );
                          }
                        } catch (e) {
                          showSnack('Erro inesperado: $e', false);
                        }
                      },

                      child: const Text(
                        "Cadastrar-se",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---------- TEXTO DE LOGIN ----------
                  RichText(
                    text: TextSpan(
                      text: "Você já tem uma conta? ",
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                      children: [
                        TextSpan(
                          text: "Entre com ela",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CredentialViewLogin(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
