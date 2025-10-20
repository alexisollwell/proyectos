import 'package:flutter/material.dart';
import '../../services/ipinfo_service.dart';

class IpInfoPage extends StatelessWidget {
  const IpInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geolocalización (IPInfo)")),
      body: FutureBuilder(
        future: getIpInfo(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final info = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "IP: ${info.ip}\nCiudad: ${info.ciudad}\nRegión: ${info.estado}\nPaís: ${info.pais}\nUbicación: ${info.loc}",
              style: const TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
