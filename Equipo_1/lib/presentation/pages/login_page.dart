import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyectos/data/services/user_service.dart';
import 'package:proyectos/presentation/pages/home_page.dart';
import 'package:proyectos/presentation/pages/register_page.dart';
import 'package:proyectos/data/services/session_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final userService = UserService();

  void _mostrarMensaje(String msg, {bool error = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _iniciarSesion() async {
    final email = emailCtrl.text.trim();
    final pass = passwordCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      _mostrarMensaje("Ingrese su correo y contraseña");
      return;
    }

    final usuario = await userService.login(email, pass);

    if (usuario == null) {
      _mostrarMensaje("Correo o contraseña incorrectos");
      return;
    }

    await SessionService.saveUserSession(usuario.id!);

    _mostrarMensaje("Bienvenido ${usuario.nombre}", error: false);

    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color.fromARGB(255, 231, 243, 251),
              Color.fromARGB(255, 212, 220, 240),
              Color.fromARGB(255, 180, 200, 236),
              Color.fromARGB(255, 161, 167, 254),
              Color.fromARGB(255, 77, 84, 209),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.globe,
                    color: Color.fromARGB(255, 59, 55, 137),
                    size: 100,
                  ),
                  const SizedBox(height: 20),

                  Text(
                    "DESCOVERY WORLD",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 48,
                      color: const Color.fromARGB(255, 69, 55, 137),
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    "Bienvenido",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 64, 55, 137),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 161, 161, 254),
                        border: Border.all(
                          color: Color.fromARGB(255, 215, 212, 240),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: emailCtrl,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Correo",
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 163, 161, 254),
                        border: Border.all(
                          color: Color.fromARGB(255, 212, 212, 240),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: passwordCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Contraseña",
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GestureDetector(
                      onTap: _iniciarSesion,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 55, 66, 137),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            "Iniciar sesión",
                            style: TextStyle(
                              color: Color.fromARGB(255, 212, 212, 240),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "¿Aun no tienes cuenta? ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Regístrese aquí",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
