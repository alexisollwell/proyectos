import 'package:flutter/material.dart';

class Constelacion {
  final String nombre;
  final String visibilidad;
  final String mejorhorario;
  final String descripcion;
  final String? imagenUrl;
  final double magnitud;
  final String familia;
  final String? id;
  final String tipo;

  Constelacion({
    required this.nombre,
    required this.visibilidad,
    required this.mejorhorario,
    required this.descripcion,
    this.imagenUrl,
    required this.magnitud,
    required this.familia,
    this.id,
    this.tipo = 'planeta',
  });

  String get nombreSoloEspanol {
    final index = nombre.indexOf(' (');
    return index > 0 ? nombre.substring(0, index) : nombre;
  }

  String get nombreSoloIngles {
    final startIndex = nombre.indexOf('(');
    final endIndex = nombre.indexOf(')');
    if (startIndex > 0 && endIndex > startIndex) {
      return nombre.substring(startIndex + 1, endIndex);
    }
    return nombre;
  }

  factory Constelacion.fromAstronomyAPI(Map<String, dynamic> data) {
    return Constelacion(
      id: data['id']?.toString(),
      nombre: data['name']?.toString() ?? 'Planeta',
      visibilidad: data['visible']?.toString() ?? 'Visible',
      mejorhorario: data['best_time']?.toString() ?? '20:00 - 23:00',
      descripcion:
          data['description']?.toString() ??
          'Planeta visible desde tu ubicación',
      magnitud: _parsearMagnitud(data['magnitude']),
      familia: data['family']?.toString() ?? 'Planeta',
      imagenUrl: data['image_url'],
      tipo: data['type']?.toString() ?? 'planeta',
    );
  }

  static double _parsearMagnitud(dynamic magnitude) {
    if (magnitude == null) return 0.0;
    if (magnitude is double) return magnitude;
    if (magnitude is int) return magnitude.toDouble();
    if (magnitude is String) return double.tryParse(magnitude) ?? 0.0;
    return 0.0;
  }

  Color get colorVisibilidad {
    return visibilidad.contains("Visible") || visibilidad.contains("visible")
        ? const Color.fromARGB(255, 76, 175, 80)
        : const Color.fromARGB(255, 244, 67, 54);
  }

  IconData get iconoVisibilidad {
    return visibilidad.contains("Visible") || visibilidad.contains("visible")
        ? Icons.visibility
        : Icons.visibility_off;
  }

  Color get colorTipo {
    switch (tipo) {
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

  IconData get iconoPlaneta {
    final nombreEspanol = nombreSoloEspanol.toLowerCase();

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

