import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:muto_system/views/teacherViews/TeacherHomeView.dart';
import '../../views/userViews/userHomeView.dart';
import 'package:muto_system/connections/credentialConnection.dart';
import 'package:muto_system/views/credentialViews/signupView.dart';
import 'package:muto_system/configs/colors.dart' as ThemeColors;

class CredentialViewLogin extends StatefulWidget {
  const CredentialViewLogin({super.key});

  @override
  State<CredentialViewLogin> createState() => _CredentialViewLoginState();
}

class _CredentialViewLoginState extends State<CredentialViewLogin> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ThemeColors.Colors.background_black,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/img/logoAtena.png", width: 150),
                  const SizedBox(height: 15),

                  // Campo EMAIL
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: "EMAIL",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Campo SENHA
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "SENHA",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  // Esqueceu senha
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Esqueceu a senha?",
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                    ),
                  ),

                  // Botão LOGIN
                  SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.Colors.background_black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        try {
                          if (email.text.isEmpty || password.text.isEmpty) {
                            showSnack('Preencha email e senha!', false);
                            return;
                          }

                          final result = await CredentialConnection.login(
                            email.text,
                            password.text,
                          );

                          if (result['status'] == true) {
                            showSnack('Login realizado com sucesso!', true);

                            final token = result['token'];
                            final user = result['user_data'] ?? result['user'];
                            final userType = result['user_type'];

                            debugPrint('Token JWT: $token');
                            debugPrint(
                              'Usuário logado: ${user['nick'] ?? user['email']}',
                            );
                            debugPrint('Tipo: $userType');

                            if (userType == 'professor') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TeacherHomeView(token: token),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserHomeView(token: token),
                                ),
                              );
                            }
                          } else {
                            showSnack(
                              result['message'] ?? 'Falha no login',
                              false,
                            );
                          }
                        } catch (e) {
                          showSnack('Erro inesperado: $e', false);
                        }
                      },

                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Cadastro
                  RichText(
                    text: TextSpan(
                      text: "Você não tem uma conta? ",
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                      children: [
                        TextSpan(
                          text: "Cadastre-se",
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
                                  builder: (context) => const CredentialView(),
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
