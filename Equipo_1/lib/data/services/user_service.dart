import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:proyectos/data/database/app_database.dart';
import 'package:proyectos/data/models/user_model.dart';

class UserService {
  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<int> registrarUsuario(Usuario usuario) async {
    final db = await AppDatabase.database;

    return await db.insert("usuarios", usuario.toMap());
  }

  Future<Usuario?> login(String email, String password) async {
    final db = await AppDatabase.database;
    final hash = hashPassword(password);

    final res = await db.query(
      "usuarios",
      where: "email = ? AND passwordHash = ?",
      whereArgs: [email, hash],
    );

    if (res.isNotEmpty) return Usuario.fromMap(res.first);
    return null;
  }

  Future<Usuario?> obtenerUsuarioPorID(int id) async {
    final db = await AppDatabase.database;

    final res = await db.query(
      "usuarios",
      where: "id = ?",
      whereArgs: [id],
    );

    if (res.isNotEmpty) return Usuario.fromMap(res.first);
    return null;
  }

  Future<int> actualizarUsuario(Usuario usuario) async {
    final db = await AppDatabase.database;

    return await db.update(
      "usuarios",
      usuario.toMap(),
      where: "id = ?",
      whereArgs: [usuario.id],
    );
  }

  Future<bool> emailExiste(String email) async {
    final db = await AppDatabase.database;

    final res = await db.query(
      "usuarios",
      where: "email = ?",
      whereArgs: [email],
    );

    return res.isNotEmpty;
  }
}
