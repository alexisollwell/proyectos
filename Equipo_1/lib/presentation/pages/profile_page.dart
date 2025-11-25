import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _editando = false;

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

    setState(() {
      _editando = false;
    });

    _mostrarMensaje("Datos actualizados correctamente", esError: false);
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
                  );
                  if (img != null) {
                    setState(() => _fotoPath = img.path);
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
                  );
                  if (img != null) {
                    setState(() => _fotoPath = img.path);
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

  void _mostrarMensaje(String msg, {bool esError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: esError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 231, 243, 251),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 55, 66, 137),
          ),
        ),
      );
    }

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
                    const SizedBox(height: 20),

                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _editando ? _mostrarSelectorFoto : null,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: const Color.fromARGB(
                              255,
                              161,
                              167,
                              254,
                            ),
                            backgroundImage: _fotoPath != null
                                ? FileImage(File(_fotoPath!))
                                : null,
                            child: _fotoPath == null
                                ? const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Color.fromARGB(255, 55, 66, 137),
                                  )
                                : null,
                          ),
                        ),
                        if (_editando)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 55, 66, 137),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "${_user!.nombre} ${_user!.apellido}",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 28,
                        color: const Color.fromARGB(255, 69, 55, 137),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      _user!.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 100, 100, 150),
                      ),
                    ),

                    const SizedBox(height: 30),

                    _buildInfoField(
                      label: "Nombre",
                      controller: _nombreCtrl,
                      icon: FontAwesomeIcons.user,
                      enabled: _editando,
                    ),

                    const SizedBox(height: 15),

                    _buildInfoField(
                      label: "Apellido",
                      controller: _apellidoCtrl,
                      icon: FontAwesomeIcons.userTag,
                      enabled: _editando,
                    ),

                    const SizedBox(height: 15),

                    _buildInfoField(
                      label: "Correo electrónico",
                      controller: _emailCtrl,
                      icon: FontAwesomeIcons.envelope,
                      enabled: _editando,
                    ),

                    const SizedBox(height: 15),

                    GestureDetector(
                      onTap: _editando
                          ? () async {
                              FocusScope.of(context).unfocus();
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() {
                                  _fechaCtrl.text =
                                      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                                });
                              }
                            }
                          : null,
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                                  controller: _fechaCtrl,
                                  enabled: false,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Fecha de nacimiento",
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 100, 100, 150),
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

                    const SizedBox(height: 30),

                    if (!_editando)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _editando = true;
                            });
                          },
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
                            child: const Center(
                              child: Text(
                                "EDITAR PERFIL",
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

                    if (_editando) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                          onTap: _guardarCambios,
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
                            child: const Center(
                              child: Text(
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

                      const SizedBox(height: 15),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _editando = false;
                              _cargarUsuario();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
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
                            child: const Center(
                              child: Text(
                                "CANCELAR",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 55, 66, 137),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangePasswordPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 180, 200, 236),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.lock,
                                color: Color.fromARGB(255, 55, 66, 137),
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "CAMBIAR CONTRASEÑA",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 55, 66, 137),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
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
            "MI PERFIL",
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

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
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
                enabled: enabled,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: label,
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
