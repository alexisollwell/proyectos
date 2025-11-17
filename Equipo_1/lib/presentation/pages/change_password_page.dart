import 'package:flutter/material.dart';
import 'package:proyectos/data/services/user_service.dart';
import 'package:proyectos/data/services/session_service.dart';
import 'package:proyectos/data/models/user_model.dart';

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
      return;
    }

    final usuario = await _service.obtenerUsuarioPorID(userId);
    if (usuario == null) {
      _mensaje("Usuario no encontrado");
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

    Navigator.pop(context);
    _mensaje("Contraseña actualizada correctamente");
  }

  void _mensaje(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cambiar contraseña"),
        backgroundColor: const Color.fromARGB(255, 55, 66, 137),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _actualController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña actual"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nuevaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Nueva contraseña"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmarController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirmar contraseña"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cargando ? null : _guardar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 55, 66, 137),
              ),
              child: _cargando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
