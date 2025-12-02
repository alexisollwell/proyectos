import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

class CompassPage extends StatefulWidget {
  const CompassPage({super.key});

  @override
  State<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Brújula")),
      body: Center(
        child: StreamBuilder<double?>(
          stream: FlutterCompass.events!.map((event) => event.heading),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Error al obtener los datos del sensor");
            }

            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            double? direction = snapshot.data;

            if (direction == null) {
              return const Text("El sensor no está disponible");
            }

            return Transform.rotate(
              angle: (direction * (math.pi / 180) * -1),
              child: Image.asset("assets/compass.png", height: 280),
            );
          },
        ),
      ),
    );
  }
}
