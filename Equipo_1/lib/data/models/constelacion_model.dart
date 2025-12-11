import 'package:flutter/material.dart';

class Constelacion {
  final String nombre;
  final String imagen;
  final String descripcion;
  final String distancia;
  final String tipo;
  final String mesesVisibilidad;
  final String significadoNombre;
  final String formaAprox;
  final String hemisferio;
  final String datoCurioso;
  final List<Offset> puntos;

  Constelacion({
    required this.nombre,
    required this.imagen,
    required this.descripcion,
    required this.distancia,
    required this.tipo,
    required this.mesesVisibilidad,
    required this.significadoNombre,
    required this.formaAprox,
    required this.hemisferio,
    required this.datoCurioso,
    this.puntos = const [],
  });
}
