import 'package:flutter/material.dart';
import 'package:proyectos/data/models/spacex_model.dart';

class ConstelacionUI {
  static Color colorVisibilidad(Constelacion c) {
    return c.visibilidad.contains("Visible") || c.visibilidad.contains("visible")
        ? const Color.fromARGB(255, 76, 175, 80)
        : const Color.fromARGB(255, 244, 67, 54);
  }

  static IconData iconoVisibilidad(Constelacion c) {
    return c.visibilidad.contains("Visible") || c.visibilidad.contains("visible")
        ? Icons.visibility
        : Icons.visibility_off;
  }

  static Color colorTipo(Constelacion c) {
    switch (c.tipo) {
      case 'estrella':
        return Colors.orange;
      case 'satelite':
        return Colors.grey;
      case 'planeta_rocoso':
        return Colors.brown;
      case 'planeta_gaseoso':
        return Colors.amber;
      case 'planeta_helado':
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }

  static IconData iconoPlaneta(Constelacion c) {
    final nombreEspanol = c.nombreSoloEspanol.toLowerCase();

    switch (nombreEspanol) {
      case 'sol':
        return Icons.wb_sunny;
      case 'luna':
        return Icons.nightlight_round;
      case 'júpiter':
        return Icons.brightness_high;
      case 'saturno':
        return Icons.circle;
      case 'marte':
        return Icons.brightness_1;
      case 'venus':
        return Icons.brightness_2;
      case 'mercurio':
        return Icons.brightness_3;
      case 'tierra':
        return Icons.public;
      case 'urano':
        return Icons.brightness_4;
      case 'neptuno':
        return Icons.brightness_5;
      default:
        return Icons.public;
    }
  }
}
