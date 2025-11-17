import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proyectos/data/models/user_model.dart';
import 'package:proyectos/data/services/user_service.dart';
import 'package:proyectos/presentation/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmarPasswordCtrl = TextEditingController();
  final fechaCtrl = TextEditingController();

  String genero = "Hombre";
  File? imagenPerfil;

  final userService = UserService();

  Future<void> _seleccionarImagen() async {
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
                  final img = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 75,
                  );
                  if (img != null) {
                    setState(() => imagenPerfil = File(img.path));
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Tomar foto"),
                onTap: () async {
                  final img = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 75,
                  );
                  if (img != null) {
                    setState(() => imagenPerfil = File(img.path));
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

  Future<String?> _guardarFotoLocal(File imagen) async {
    final directory = await getApplicationDocumentsDirectory();
    final path =
        "${directory.path}/perfil_${DateTime.now().millisecondsSinceEpoch}.jpg";

    final newImage = await imagen.copy(path);
    return newImage.path;
  }

  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordCtrl.text != confirmarPasswordCtrl.text) {
      _mostrarMensaje("Las contraseñas no coinciden");
      return;
    }

    if (await userService.emailExiste(emailCtrl.text)) {
      _mostrarMensaje("El correo ya está registrado");
      return;
    }

    String? fotoPath;
    if (imagenPerfil != null) {
      fotoPath = await _guardarFotoLocal(imagenPerfil!);
    }

    final usuario = Usuario(
      email: emailCtrl.text.trim(),
      passwordHash: UserService.hashPassword(passwordCtrl.text),
      nombre: nombreCtrl.text.trim(),
      apellido: apellidoCtrl.text.trim(),
      genero: genero,
      fotoPath: fotoPath,
      fechaNacimiento: fechaCtrl.text.trim(),
    );

    await userService.registrarUsuario(usuario);

    _mostrarMensaje("Registro exitoso", esError: false);

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  void _mostrarMensaje(String msg, {bool esError = true}) {
    final color = esError ? Colors.red : Colors.green;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Cuenta"),
        backgroundColor: const Color.fromARGB(255, 77, 84, 209),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _seleccionarImagen,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      imagenPerfil != null ? FileImage(imagenPerfil!) : null,
                  child: imagenPerfil == null
                      ? const Icon(Icons.camera_alt, size: 35)
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) => v!.isEmpty ? "Ingrese un nombre" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: apellidoCtrl,
                decoration: const InputDecoration(labelText: "Apellido"),
                validator: (v) => v!.isEmpty ? "Ingrese un apellido" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Correo"),
                validator: (v) =>
                    v!.contains("@") ? null : "Ingrese un correo válido",
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
                validator: (v) =>
                    v!.length < 6 ? "Mínimo 6 caracteres" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: confirmarPasswordCtrl,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "Confirmar Contraseña"),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: fechaCtrl,
                decoration:
                    const InputDecoration(labelText: "Fecha de nacimiento"),
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    fechaCtrl.text =
                        "${date.year}-${date.month}-${date.day}";
                  }
                },
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField(
                value: genero,
                decoration: const InputDecoration(labelText: "Género"),
                items: const [
                  DropdownMenuItem(value: "Hombre", child: Text("Hombre")),
                  DropdownMenuItem(value: "Mujer", child: Text("Mujer")),
                  DropdownMenuItem(value: "Otro", child: Text("Otro")),
                ],
                onChanged: (value) => genero = value!,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _registrarUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 55, 66, 137),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("Registrarse"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
