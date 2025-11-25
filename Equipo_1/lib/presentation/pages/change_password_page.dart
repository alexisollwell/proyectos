import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyectos/data/services/user_service.dart';
import 'package:proyectos/data/services/session_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _actualController = TextEditingController();
  final _nuevaController = TextEditingController();
  final _confirmarController = TextEditingController();

  final _service = UserService();
  bool _cargando = false;

  Future<void> _guardar() async {
    final actual = _actualController.text.trim();
    final nueva = _nuevaController.text.trim();
    final confirmar = _confirmarController.text.trim();

    if (actual.isEmpty || nueva.isEmpty || confirmar.isEmpty) {
      _mensaje("Todos los campos son obligatorios");
      return;
    }

    if (nueva.length < 6) {
      _mensaje("La contraseña debe tener al menos 6 caracteres");
      return;
    }

    if (nueva != confirmar) {
      _mensaje("Las contraseñas no coinciden");
      return;
    }

    setState(() => _cargando = true);

    final userId = await SessionService.getUserId();
    if (userId == null) {
      _mensaje("Error al obtener usuario");
      setState(() => _cargando = false);
      return;
    }

    final usuario = await _service.obtenerUsuarioPorID(userId);
    if (usuario == null) {
      _mensaje("Usuario no encontrado");
      setState(() => _cargando = false);
      return;
    }

    final hashActual = UserService.hashPassword(actual);
    if (usuario.passwordHash != hashActual) {
      _mensaje("La contraseña actual es incorrecta");
      setState(() => _cargando = false);
      return;
    }

    usuario.passwordHash = UserService.hashPassword(nueva);
    await _service.actualizarUsuario(usuario);

    setState(() => _cargando = false);

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    _mensaje("Contraseña actualizada correctamente", esError: false);
  }

  void _mensaje(String msg, {bool esError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: esError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 243, 251),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    const FaIcon(
                      FontAwesomeIcons.lock,
                      color: Color.fromARGB(255, 59, 55, 137),
                      size: 80,
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "CAMBIAR CONTRASEÑA",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 32,
                        color: const Color.fromARGB(255, 69, 55, 137),
                      ),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      "Actualiza tu contraseña de acceso",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 64, 55, 137),
                      ),
                    ),

                    const SizedBox(height: 40),

                    _buildTextField(
                      controller: _actualController,
                      hintText: "Contraseña actual",
                      obscureText: true,
                      icon: FontAwesomeIcons.lock,
                    ),

                    const SizedBox(height: 20),

                    _buildTextField(
                      controller: _nuevaController,
                      hintText: "Nueva contraseña",
                      obscureText: true,
                      icon: FontAwesomeIcons.key,
                    ),

                    const SizedBox(height: 20),

                    _buildTextField(
                      controller: _confirmarController,
                      hintText: "Confirmar contraseña",
                      obscureText: true,
                      icon: FontAwesomeIcons.checkDouble,
                    ),

                    const SizedBox(height: 40),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GestureDetector(
                        onTap: _cargando ? null : _guardar,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 55, 66, 137),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _cargando
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Color.fromARGB(255, 212, 212, 240),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "GUARDAR CAMBIOS",
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

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 161, 167, 254),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color.fromARGB(255, 55, 66, 137),
                size: 20,
              ),
            ),
          ),

          Text(
            "CONTRASEÑA",
            style: GoogleFonts.bebasNeue(
              fontSize: 20,
              color: const Color.fromARGB(255, 69, 55, 137),
            ),
          ),

          Container(width: 44),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 161, 167, 254),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            FaIcon(
              icon,
              color: const Color.fromARGB(255, 55, 66, 137),
              size: 18,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 100, 100, 150),
                  ),
                ),
                style: const TextStyle(color: Color.fromARGB(255, 55, 66, 137)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
