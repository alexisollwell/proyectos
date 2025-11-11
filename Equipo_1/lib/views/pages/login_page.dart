import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyectos/views/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              // Color(0xffF9FBE7),
              // Color(0xffF0EDD4),
              // Color(0xffECCDB4),
              // Color(0xffFEA1A1),
              // Color(0xffD14D72),
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
                  FaIcon(
                    FontAwesomeIcons.globe,
                    color: Color.fromARGB(255, 59, 55, 137),
                    size: 100,
                  ),
                  SizedBox(height: 20),

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
                      //fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 161, 161, 254),
                        border: Border.all(
                          color: const Color.fromARGB(255, 215, 212, 240),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: TextField(
                          decoration: InputDecoration(
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
                          color: const Color.fromARGB(255, 212, 212, 240),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 55, 66, 137),
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

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "¿Aun no tienes cuenta? ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Registrese aqui",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 25),
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
