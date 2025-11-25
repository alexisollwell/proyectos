import 'package:proyectos/data/models/coordenadas_celestiales.dart';
import 'package:proyectos/data/models/estrella.dart';

class Constelacion {
  final String nombre;
  final CoordenadasCelestiales coordinates;
  final List<Estrella> estrellas;
  final bool isFixed;

  const Constelacion({
    required this.nombre,
    required this.coordinates,
    required this.estrellas,
    this.isFixed = false,
  });

  Constelacion copyWith({
    bool? isFixed,
    double? fixedAltitude,
    double? fixedAzimuth,
  }) {
    return Constelacion(
      nombre: nombre,
      coordinates: coordinates.copyWith(
        fixedAltitude: fixedAltitude,
        fixedAzimuth: fixedAzimuth,
      ),
      estrellas: estrellas,
      isFixed: isFixed ?? this.isFixed,
    );
  }
}
