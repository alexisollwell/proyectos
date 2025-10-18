import 'package:flutter/material.dart';
import 'package:equipo1_practica5/models/spacex_model.dart';
import 'package:equipo1_practica5/services/spacex_service.dart';

class PaginaConstelacion extends StatefulWidget {
  final double latitude;
  final double longitude;

  const PaginaConstelacion({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<PaginaConstelacion> createState() => _PaginaConstelacionState();
}

class _PaginaConstelacionState extends State<PaginaConstelacion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Constelaciones Visibles")),
      body: FutureBuilder<Constelacion>(
        future: getConstelacion(widget.latitude, widget.longitude),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Buscando constelaciones..."),
                ],
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text("Error al cargar las constelaciones"),
            );
          }

          final constelacion = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          constelacion.nombre,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          "👁️",
                          "Visibilidad:",
                          constelacion.visibilidad,
                        ),
                        _buildInfoRow(
                          "⏰",
                          "Mejor horario:",
                          constelacion.mejorhorario,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          constelacion.descripcion,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Consejos para observar:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildTip("Busca un lugar con poca contaminación lumínica"),
                _buildTip(
                  "Espera 15 minutos para que tus ojos se adapten a la oscuridad",
                ),
                _buildTip(
                  "Usa una app de astronomía para identificar constelaciones",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(emoji),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• "),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
