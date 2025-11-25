import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _cargando = false;

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
                leading: const Icon(
                  Icons.photo_library,
                  color: Color.fromARGB(255, 55, 66, 137),
                ),
                title: const Text(
                  "Elegir de galería",
                  style: TextStyle(color: Color.fromARGB(255, 55, 66, 137)),
                ),
                onTap: () async {
                  final img = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 75,
                  );
                  if (img != null) {
                    setState(() => imagenPerfil = File(img.path));
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Color.fromARGB(255, 55, 66, 137),
                ),
                title: const Text(
                  "Tomar foto",
                  style: TextStyle(color: Color.fromARGB(255, 55, 66, 137)),
                ),
                onTap: () async {
                  final img = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 75,
                  );
                  if (img != null) {
                    setState(() => imagenPerfil = File(img.path));
                  }
                  // ignore: use_build_context_synchronously
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

    setState(() => _cargando = true);

    if (await userService.emailExiste(emailCtrl.text)) {
      _mostrarMensaje("El correo ya está registrado");
      setState(() => _cargando = false);
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

    setState(() => _cargando = false);

    _mostrarMensaje("Registro exitoso", esError: false);

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  void _mostrarMensaje(String msg, {bool esError = true}) {
    final color = esError ? Colors.red : Colors.green;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "CREAR CUENTA",
                        style: GoogleFonts.bebasNeue(
                          fontSize: 32,
                          color: const Color.fromARGB(255, 69, 55, 137),
                        ),
                      ),
                      const SizedBox(height: 10),

                      const Text(
                        "Únete a Descovery World",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 64, 55, 137),
                        ),
                      ),

                      const SizedBox(height: 30),

                      GestureDetector(
                        onTap: _seleccionarImagen,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: const Color.fromARGB(
                                255,
                                161,
                                167,
                                254,
                              ),
                              backgroundImage: imagenPerfil != null
                                  ? FileImage(imagenPerfil!)
                                  : null,
                              child: imagenPerfil == null
                                  ? const Icon(
                                      Icons.camera_alt,
                                      size: 35,
                                      color: Color.fromARGB(255, 55, 66, 137),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 55, 66, 137),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      _buildTextField(
                        controller: nombreCtrl,
                        hintText: "Nombre",
                        icon: FontAwesomeIcons.user,
                        validator: (v) =>
                            v!.isEmpty ? "Ingrese un nombre" : null,
                      ),

                      const SizedBox(height: 15),

                      _buildTextField(
                        controller: apellidoCtrl,
                        hintText: "Apellido",
                        icon: FontAwesomeIcons.userTag,
                        validator: (v) =>
                            v!.isEmpty ? "Ingrese un apellido" : null,
                      ),

                      const SizedBox(height: 15),

                      _buildTextField(
                        controller: emailCtrl,
                        hintText: "Correo electrónico",
                        icon: FontAwesomeIcons.envelope,
                        validator: (v) => v!.contains("@")
                            ? null
                            : "Ingrese un correo válido",
                      ),

                      const SizedBox(height: 15),

                      _buildTextField(
                        controller: passwordCtrl,
                        hintText: "Contraseña",
                        icon: FontAwesomeIcons.lock,
                        obscureText: true,
                        validator: (v) =>
                            v!.length < 6 ? "Mínimo 6 caracteres" : null,
                      ),

                      const SizedBox(height: 15),

                      _buildTextField(
                        controller: confirmarPasswordCtrl,
                        hintText: "Confirmar contraseña",
                        icon: FontAwesomeIcons.checkDouble,
                        obscureText: true,
                      ),

                      const SizedBox(height: 15),

                      GestureDetector(
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
                                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                          }
                        },
                        child: Container(
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.calendar,
                                  color: Color.fromARGB(255, 55, 66, 137),
                                  size: 18,
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: TextFormField(
                                    controller: fechaCtrl,
                                    enabled: false,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Fecha de nacimiento",
                                      hintStyle: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          100,
                                          100,
                                          150,
                                        ),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 55, 66, 137),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Container(
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
                          child: DropdownButtonFormField(
                            // ignore: deprecated_member_use
                            value: genero,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Género",
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "Hombre",
                                child: Text(
                                  "Hombre",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 55, 66, 137),
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "Mujer",
                                child: Text(
                                  "Mujer",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 55, 66, 137),
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "Otro",
                                child: Text(
                                  "Otro",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 55, 66, 137),
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => genero = value!),
                            dropdownColor: const Color.fromARGB(
                              255,
                              212,
                              212,
                              240,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                          onTap: _cargando ? null : _registrarUsuario,
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
                                        color: Color.fromARGB(
                                          255,
                                          212,
                                          212,
                                          240,
                                        ),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "REGISTRARSE",
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          212,
                                          212,
                                          240,
                                        ),
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
            "REGISTRO",
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
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
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
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                validator: validator,
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
