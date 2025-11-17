import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyectos/data/services/session_service.dart';
import 'package:proyectos/presentation/pages/constelacion_page.dart';
import 'package:proyectos/presentation/pages/location_page_integrada.dart';
import 'package:proyectos/presentation/pages/spacex_page.dart';
import 'package:proyectos/presentation/pages/login_page.dart';
import 'package:proyectos/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 243, 251),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 30),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildOpcionMenu(
                      icono: FontAwesomeIcons.camera,
                      titulo: "Realidad Aumentada",
                      descripcion: "Visualiza constelaciones con tu cámara",
                      colorFondo: const Color.fromARGB(255, 161, 167, 254),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConstelacionARPage(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    _buildOpcionMenu(
                      icono: FontAwesomeIcons.star,
                      titulo: "Ver Constelación Visible",
                      descripcion:
                          "Observa las constelaciones actuales según tu ubicación",
                      colorFondo: const Color.fromARGB(255, 180, 200, 236),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaginaConstelacion(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    _buildOpcionMenu(
                      icono: FontAwesomeIcons.mapLocationDot,
                      titulo: "Geolocalización & Mapa",
                      descripcion: "Tu ubicación IP y mapa integrados",
                      colorFondo: const Color.fromARGB(255, 161, 167, 254),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                IntegratedLocationPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              await SessionService.logout();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 161, 167, 254),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 55, 66, 137),
                size: 20,
              ),
            ),
          ),

          Text(
            "DESCOVERY WORLD",
            style: GoogleFonts.bebasNeue(
              fontSize: 24,
              color: const Color.fromARGB(255, 69, 55, 137),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 161, 167, 254),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color.fromARGB(255, 55, 66, 137),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcionMenu({
    required IconData icono,
    required String titulo,
    required String descripcion,
    required Color colorFondo,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorFondo,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 55, 66, 137),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FaIcon(
                icono,
                color: const Color.fromARGB(255, 212, 212, 240),
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 55, 66, 137),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    descripcion,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 77, 84, 209),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color.fromARGB(255, 55, 66, 137),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
