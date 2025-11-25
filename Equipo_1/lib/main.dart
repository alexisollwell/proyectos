import 'package:flutter/material.dart';
import 'package:proyectos/data/services/session_service.dart';
import 'package:proyectos/presentation/pages/home_page.dart';
import 'package:proyectos/presentation/pages/login_page.dart';
import 'package:proyectos/presentation/pages/change_password_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userId = await SessionService.getUserSession();

  runApp(MyApp(userId: userId));
}

class MyApp extends StatelessWidget {
  final int? userId;

  const MyApp({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userId == null ? const LoginPage() : const HomePage(),
      routes: {"/cambiar_contra": (context) => const ChangePasswordPage()},
    );
  }
}
