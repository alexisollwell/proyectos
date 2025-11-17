import 'estrella.dart';
import 'coordenadas_celestiales.dart';

class Constelacion {
  final String nombre;
  final List<Estrella> estrellas;
  final CoordenadasCelestiales coordinates;

  Constelacion({
    required this.nombre,
    required this.estrellas,
    required this.coordinates,
  });
}