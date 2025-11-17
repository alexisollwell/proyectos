import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyectos/data/models/user_model.dart';
import 'package:proyectos/data/services/user_service.dart';
import 'package:proyectos/data/services/session_service.dart';
import 'package:proyectos/presentation/pages/change_password_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();

  Usuario? _user;

  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _apellidoCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _fechaCtrl = TextEditingController();

  String? _fotoPath;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final id = await SessionService.getUserId();
    if (id == null) return;

    final user = await _userService.obtenerUsuarioPorID(id);

    if (user != null) {
      setState(() {
        _user = user;
        _nombreCtrl.text = user.nombre;
        _apellidoCtrl.text = user.apellido;
        _emailCtrl.text = user.email;
        _fechaCtrl.text = user.fechaNacimiento;
        _fotoPath = user.fotoPath;
        _cargando = false;
      });
    }
  }

  Future<void> _guardarCambios() async {
    if (_user == null) return;

    _user!
      ..nombre = _nombreCtrl.text
      ..apellido = _apellidoCtrl.text
      ..email = _emailCtrl.text
      ..fechaNacimiento = _fechaCtrl.text
      ..fotoPath = _fotoPath;

    await _userService.actualizarUsuario(_user!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Datos actualizados correctamente")),
    );
  }

  Future<void> _mostrarSelectorFoto() async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Elegir de galería"),
                onTap: () async {
                  final img = await picker.pickImage(source: ImageSource.gallery);
                  if (img != null) {
                    setState(() => _fotoPath = img.path);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Tomar foto"),
                onTap: () async {
                  final img = await picker.pickImage(source: ImageSource.camera);
                  if (img != null) {
                    setState(() => _fotoPath = img.path);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Perfil"),
        backgroundColor: const Color.fromARGB(255, 55, 66, 137),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _mostrarSelectorFoto,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    _fotoPath != null ? FileImage(File(_fotoPath!)) : null,
                child: _fotoPath == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            _input("Nombre", _nombreCtrl),
            const SizedBox(height: 10),

            _input("Apellido", _apellidoCtrl),
            const SizedBox(height: 10),

            _input("Correo electrónico", _emailCtrl),
            const SizedBox(height: 10),

            _input("Fecha de nacimiento (AAAA-MM-DD)", _fechaCtrl),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 55, 66, 137),
              ),
              onPressed: _guardarCambios,
              child: const Text("Guardar cambios"),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/cambiar_contra");
              },
              child: const Text("Cambiar contraseña"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
