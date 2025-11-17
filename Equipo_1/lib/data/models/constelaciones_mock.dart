import 'coordenadas_celestiales.dart';
import 'constelacion.dart';
import 'estrella.dart';

final List<Constelacion> constelacionesMock = [
  Constelacion(
    nombre: "Osa Mayor",
    coordinates: CoordenadasCelestiales(altitude: 0.5, azimuth: 0.3),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 1.0, connections: [1, 2]),
      Estrella(x: 1.0, y: 0.5, brightness: 0.8, connections: [0, 3]),
      Estrella(x: -1.0, y: 0.3, brightness: 0.7, connections: [0, 4]),
      Estrella(x: 2.0, y: 1.0, brightness: 0.6, connections: [1, 5]),
      Estrella(x: -2.0, y: 1.2, brightness: 0.5, connections: [2, 6]),
      Estrella(x: 3.0, y: 1.5, brightness: 0.4, connections: [3]),
      Estrella(x: -3.0, y: 1.8, brightness: 0.3, connections: [4]),
    ],
  ),
  Constelacion(
    nombre: "Orión",
    coordinates: CoordenadasCelestiales(altitude: 0.7, azimuth: 1.2),
    estrellas: [
      Estrella(x: 0.5, y: 0.0, brightness: 1.0, connections: [1, 2]),
      Estrella(x: 1.5, y: 0.8, brightness: 0.9, connections: [0, 3]),
      Estrella(x: -0.5, y: 0.8, brightness: 0.8, connections: [0, 4]),
      Estrella(x: 2.0, y: 1.5, brightness: 0.7, connections: [1, 5]),
      Estrella(x: -1.0, y: 1.5, brightness: 0.6, connections: [2, 6]),
      Estrella(x: 2.5, y: 2.2, brightness: 0.5, connections: [3]),
      Estrella(x: -1.5, y: 2.2, brightness: 0.4, connections: [4]),
    ],
  ),
  Constelacion(
    nombre: "Casiopea",
    coordinates: CoordenadasCelestiales(altitude: 0.9, azimuth: 2.0),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 0.9, connections: [1]),
      Estrella(x: 1.0, y: -0.5, brightness: 0.8, connections: [0, 2]),
      Estrella(x: 2.0, y: 0.0, brightness: 0.7, connections: [1, 3]),
      Estrella(x: 1.0, y: 0.5, brightness: 0.6, connections: [2, 4]),
      Estrella(x: 0.0, y: 1.0, brightness: 0.5, connections: [3]),
    ],
  ),
  Constelacion(
    nombre: "Leo",
    coordinates: CoordenadasCelestiales(altitude: 0.6, azimuth: 1.8),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 0.9, connections: [1, 2]),
      Estrella(x: 1.0, y: 0.3, brightness: 0.8, connections: [0, 3]),
      Estrella(x: -0.5, y: 0.5, brightness: 0.7, connections: [0, 4]),
      Estrella(x: 1.5, y: 0.8, brightness: 0.6, connections: [1, 5]),
      Estrella(x: -1.0, y: 1.0, brightness: 0.5, connections: [2, 6]),
      Estrella(x: 2.0, y: 1.2, brightness: 0.4, connections: [3]),
      Estrella(x: -1.5, y: 1.5, brightness: 0.3, connections: [4]),
    ],
  ),
  Constelacion(
    nombre: "Escorpio",
    coordinates: CoordenadasCelestiales(altitude: 0.4, azimuth: 2.5),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 0.9, connections: [1]),
      Estrella(x: 0.8, y: -0.3, brightness: 0.8, connections: [0, 2]),
      Estrella(x: 1.5, y: -0.6, brightness: 0.7, connections: [1, 3]),
      Estrella(x: 2.0, y: -0.9, brightness: 0.6, connections: [2, 4]),
      Estrella(x: 2.5, y: -1.2, brightness: 0.5, connections: [3, 5]),
      Estrella(x: 3.0, y: -1.5, brightness: 0.4, connections: [4]),
    ],
  ),
  Constelacion(
    nombre: "Lyra",
    coordinates: CoordenadasCelestiales(altitude: 0.8, azimuth: 3.0),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 1.0, connections: [1, 2, 3]),
      Estrella(x: 0.5, y: 0.5, brightness: 0.7, connections: [0]),
      Estrella(x: -0.5, y: 0.5, brightness: 0.6, connections: [0]),
      Estrella(x: 0.0, y: -0.5, brightness: 0.8, connections: [0]),
    ],
  ),
  Constelacion(
    nombre: "Cruz del Sur",
    coordinates: CoordenadasCelestiales(altitude: 0.3, azimuth: 3.5),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 0.9, connections: [1, 2]),
      Estrella(x: 0.0, y: 1.0, brightness: 0.8, connections: [0, 3]),
      Estrella(x: 0.5, y: 0.0, brightness: 0.7, connections: [0, 4]),
      Estrella(x: 0.0, y: 1.5, brightness: 0.6, connections: [1]),
      Estrella(x: 1.0, y: 0.0, brightness: 0.5, connections: [2]),
    ],
  ),
  Constelacion(
    nombre: "Andrómeda",
    coordinates: CoordenadasCelestiales(altitude: 0.7, azimuth: 0.8),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 0.9, connections: [1]),
      Estrella(x: 1.0, y: 0.2, brightness: 0.8, connections: [0, 2]),
      Estrella(x: 2.0, y: 0.4, brightness: 0.7, connections: [1, 3]),
      Estrella(x: 3.0, y: 0.6, brightness: 0.6, connections: [2, 4]),
      Estrella(x: 4.0, y: 0.8, brightness: 0.5, connections: [3]),
    ],
  ),
  Constelacion(
    nombre: "Perseo",
    coordinates: CoordenadasCelestiales(altitude: 0.6, azimuth: 1.0),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 0.9, connections: [1, 2]),
      Estrella(x: 0.8, y: 0.5, brightness: 0.8, connections: [0, 3]),
      Estrella(x: -0.8, y: 0.3, brightness: 0.7, connections: [0, 4]),
      Estrella(x: 1.5, y: 1.0, brightness: 0.6, connections: [1]),
      Estrella(x: -1.5, y: 0.8, brightness: 0.5, connections: [2]),
    ],
  ),
  Constelacion(
    nombre: "Tauro",
    coordinates: CoordenadasCelestiales(altitude: 0.5, azimuth: 1.5),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 0.9, connections: [1, 2]),
      Estrella(x: 0.7, y: 0.4, brightness: 0.8, connections: [0, 3]),
      Estrella(x: -0.7, y: 0.4, brightness: 0.7, connections: [0, 4]),
      Estrella(x: 1.2, y: 0.8, brightness: 0.6, connections: [1]),
      Estrella(x: -1.2, y: 0.8, brightness: 0.5, connections: [2]),
    ],
  ),
  Constelacion(
    nombre: "Geminis",
    coordinates: CoordenadasCelestiales(altitude: 0.8, azimuth: 2.2),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 0.9, connections: [1, 2]),
      Estrella(x: 1.0, y: 0.0, brightness: 0.8, connections: [0, 3]),
      Estrella(x: -1.0, y: 0.0, brightness: 0.7, connections: [0, 4]),
      Estrella(x: 2.0, y: 0.0, brightness: 0.6, connections: [1]),
      Estrella(x: -2.0, y: 0.0, brightness: 0.5, connections: [2]),
    ],
  ),
  Constelacion(
    nombre: "Acuario",
    coordinates: CoordenadasCelestiales(altitude: 0.4, azimuth: 3.2),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 0.9, connections: [1]),
      Estrella(x: 0.5, y: -0.3, brightness: 0.8, connections: [0, 2]),
      Estrella(x: 1.0, y: -0.6, brightness: 0.7, connections: [1, 3]),
      Estrella(x: 1.5, y: -0.9, brightness: 0.6, connections: [2, 4]),
      Estrella(x: 2.0, y: -1.2, brightness: 0.5, connections: [3]),
    ],
  ),
  Constelacion(
    nombre: "Capricornio",
    coordinates: CoordenadasCelestiales(altitude: 0.3, azimuth: 2.8),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 0.9, connections: [1, 2]),
      Estrella(x: 0.6, y: -0.4, brightness: 0.8, connections: [0, 3]),
      Estrella(x: -0.6, y: -0.4, brightness: 0.7, connections: [0, 4]),
      Estrella(x: 1.2, y: -0.8, brightness: 0.6, connections: [1]),
      Estrella(x: -1.2, y: -0.8, brightness: 0.5, connections: [2]),
    ],
  ),
  Constelacion(
    nombre: "Sagitario",
    coordinates: CoordenadasCelestiales(altitude: 0.2, azimuth: 3.0),
    estrellas: [
      Estrella(x: 0.0, y: 0.0, brightness: 0.9, connections: [1, 2]),
      Estrella(x: 0.5, y: 0.3, brightness: 0.8, connections: [0, 3]),
      Estrella(x: -0.5, y: 0.3, brightness: 0.7, connections: [0, 4]),
      Estrella(x: 1.0, y: 0.6, brightness: 0.6, connections: [1]),
      Estrella(x: -1.0, y: 0.6, brightness: 0.5, connections: [2]),
    ],
  ),
];