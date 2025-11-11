import 'package:flutter/material.dart';
import 'package:proyectos/views/pages/login_page.dart';
import 'views/pages/users_page.dart';
import 'views/pages/spacex_page.dart';
import 'views/pages/ipinfo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto APIs',
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Proyecto 3 APIs")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Usuarios - Reqres"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersPage()),
              ),
            ),
            ElevatedButton(
              child: const Text("Ver Constelación Visible"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaginaConstelacion(
                    latitude: 32.5149, // Tu latitud
                    longitude: -117.0382, // Tu longitud
                  ),
                ),
              ),
            ),
            ElevatedButton(
              child: const Text("Mi ubicación - IPInfo"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IpInfoPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
