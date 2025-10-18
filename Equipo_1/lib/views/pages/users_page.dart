import 'package:flutter/material.dart';
import '../../services/user_service.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuarios (Reqres API)")),
      body: FutureBuilder(
        future: getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final u = users[index];
              return ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(u.avatar)),
                title: Text("${u.primerNombre} ${u.apellido}"),
                subtitle: Text(u.correo),
              );
            },
          );
        },
      ),
    );
  }
}
