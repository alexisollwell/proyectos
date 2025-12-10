import 'package:flutter/material.dart';
import 'package:proyectos/data/models/constelacion_model.dart';

final List<Constelacion> constelaciones = [
  Constelacion(
    nombre: "Osa Mayor",
    imagen: "assets/constelaciones/osa_mayor.jpg",
    descripcion:
        "Una de las constelaciones más conocidas del hemisferio norte, famosa por su asterismo 'El Carro'.",
    distancia: "80 – 130 años luz",
    tipo: "Boreal",
    mesesVisibilidad: "Marzo – Junio",
    significadoNombre: "Representa a una gran osa.",
    formaAprox: "Carro o cazo",
    hemisferio: "Norte",
    datoCurioso:
        "Es una constelación circumpolar, visible todo el año en zonas del norte.",
    puntos: [
      Offset(0.12, 0.31), // Punta mango
      Offset(0.32, 0.31),
      Offset(0.43, 0.39),
      Offset(0.57, 0.47), // Unión cazo
      Offset(0.59, 0.60), // Fondo cazo abajo
      Offset(0.82, 0.66), // Frente abajo
      Offset(0.89, 0.50), // Frente arriba (Dubhe)
      Offset(0.57, 0.47), // Cierre cazo
    ],
  ),

  Constelacion(
    nombre: "Orión",
    imagen: "assets/constelaciones/orion.jpg",
    descripcion:
        "Una de las constelaciones más brillantes y distintivas. Hogar de Betelgeuse y Rigel.",
    distancia: "1,300 años luz",
    tipo: "Boreal",
    mesesVisibilidad: "Noviembre – Febrero",
    significadoNombre: "El cazador de la mitología griega.",
    formaAprox: "Cazador con cinturón",
    hemisferio: "Visible en ambos, predominante en el norte",
    datoCurioso:
        "Sus tres estrellas centrales forman el famoso 'Cinturón de Orión'.",
    puntos: [
      Offset(0.31, 0.205),
      Offset(0.348, 0.261),
      Offset(0.440, 0.503),
      Offset(0.348, 0.261),
      Offset(0.479, 0.189),
      Offset(0.539, 0.284),
      Offset(0.495, 0.46),
      Offset(0.47, 0.48),
      Offset(0.440, 0.503),
      Offset(0.395, 0.705),
      Offset(0.615, 0.665),
      Offset(0.495, 0.46),
      Offset(0.539, 0.284),
      Offset(0.776, 0.269),
      Offset(0.77, 0.22),
      Offset(0.74, 0.185),
      Offset(0.77, 0.22),
      Offset(0.776, 0.269),
      Offset(0.763, 0.303),
      Offset(0.747, 0.383),
      Offset(0.712, 0.4),
    ],
  ),

  Constelacion(
    nombre: "Casiopea",
    imagen: "assets/constelaciones/casiopea.jpg",
    descripcion:
        "Constelación con forma de 'W' muy fácil de identificar en el cielo del norte.",
    distancia: "550 años luz",
    tipo: "Boreal",
    mesesVisibilidad: "Todo el año (circumpolar)",
    significadoNombre: "Reina vanidosa de la mitología griega.",
    formaAprox: "Letra 'W'",
    hemisferio: "Norte",
    datoCurioso:
        "Una de las constelaciones más usadas para localizar la estrella Polar.",
    puntos: [
      Offset(0.16, 0.25),
      Offset(0.31, 0.46),
      Offset(0.51, 0.45), // Pico central W
      Offset(0.63, 0.66),
      Offset(0.83, 0.49),
    ],
  ),

  Constelacion(
    nombre: "Leo",
    imagen: "assets/constelaciones/leo.jpg",
    descripcion:
        "Una de las constelaciones zodiacales más conocidas, representa a un león.",
    distancia: "79 – 130 años luz",
    tipo: "Zodiacal",
    mesesVisibilidad: "Febrero – Mayo",
    significadoNombre: "El león del Zodiaco.",
    formaAprox: "León recostado",
    hemisferio: "Norte",
    datoCurioso: "Regulus es una de las estrellas más brillantes del cielo.",
    puntos: [
      Offset(0.81, 0.14), // Cabeza arriba
      Offset(0.72, 0.105),
      Offset(0.608, 0.245),
      Offset(0.64, 0.355),
      Offset(0.75, 0.40), // Regulus
      Offset(0.81, 0.54), // Cuello
      Offset(0.33, 0.63), // Cuerpo
      Offset(0.145, 0.705), // Cola estaa
      Offset(0.285, 0.48), // Cuerpo
      Offset(0.64, 0.355),
    ],
  ),

  Constelacion(
    nombre: "Escorpio",
    imagen: "assets/constelaciones/escorpio.jpg",
    descripcion:
        "Constelación zodiacal fácilmente reconocible por su forma de escorpión.",
    distancia: "400 – 600 años luz",
    tipo: "Zodiacal",
    mesesVisibilidad: "Junio – Agosto",
    significadoNombre: "El escorpión del Zodiaco.",
    formaAprox: "Escorpión con cola curva",
    hemisferio: "Sur",
    datoCurioso: "Antares es conocida como 'el corazón del escorpión'.",
    puntos: [
      Offset(0.80, 0.105), // Arriba
      Offset(0.825, 0.18), // Pinzas
      Offset(0.82, 0.265), // Pinzas
      Offset(0.815, 0.34), // Pinzas
      Offset(0.82, 0.265), // Pinzas
      Offset(0.825, 0.18), // Pinzas
      Offset(0.67, 0.23),
      Offset(0.615, 0.268),
      Offset(0.575, 0.30),
      Offset(0.48, 0.44), // Antares
      Offset(0.458, 0.55),
      Offset(0.432, 0.655),
      Offset(0.325, 0.667), // continuar
      Offset(0.197, 0.665), // Curva cola
      Offset(0.135, 0.589), // Aguijón
      Offset(0.17, 0.545), // Aguijón
      Offset(0.22, 0.495), // Aguijón
    ],
  ),

  Constelacion(
    nombre: "Lyra",
    imagen: "assets/constelaciones/lyra.jpg",
    descripcion:
        "Pequeña constelación del hemisferio norte, hogar de la brillante estrella Vega.",
    distancia: "25 – 162 años luz",
    tipo: "Boreal",
    mesesVisibilidad: "Junio – Octubre",
    significadoNombre: "La lira de Orfeo.",
    formaAprox: "Instrumento musical",
    hemisferio: "Norte",
    datoCurioso: "Vega es una de las estrellas más estudiadas del universo.",
    puntos: [
      Offset(0.685, 0.235), // Vega
      Offset(0.56, 0.33),
      Offset(0.395, 0.40),
      Offset(0.31, 0.735),
      Offset(0.465, 0.685),
      Offset(0.56, 0.33), // Cierre rombo
    ],
  ),

  Constelacion(
    nombre: "Cruz del Sur",
    imagen: "assets/constelaciones/cruz_del_sur.jpg",
    descripcion:
        "Una de las constelaciones más importantes del hemisferio sur, símbolo de navegación.",
    distancia: "88 – 364 años luz",
    tipo: "Austral",
    mesesVisibilidad: "Marzo – Julio",
    significadoNombre: "La cruz guía del sur.",
    formaAprox: "Cruz inclinada",
    hemisferio: "Sur",
    datoCurioso: "Se usa para encontrar el punto cardinal sur.",
    puntos: [
      Offset(0.508, 0.262), // Arriba
      Offset(0.36, 0.705), // Abajo
      Offset(0.43, 0.50), // Centro (ficticio para conectar)
      Offset(0.30, 0.485), // Izq
      Offset(0.43, 0.50), // Centro (ficticio para conectar)
      Offset(0.668, 0.50), // Der
    ],
  ),

  Constelacion(
    nombre: "Andrómeda",
    imagen: "assets/constelaciones/andromeda.jpg",
    descripcion:
        "Famosa por contener la galaxia de Andrómeda (M31), visible a simple vista.",
    distancia: "2.5 millones de años luz (M31)",
    tipo: "Boreal",
    mesesVisibilidad: "Agosto – Enero",
    significadoNombre: "Princesa encadenada de la mitología griega.",
    formaAprox: "Cadena o figura alargada",
    hemisferio: "Norte",
    datoCurioso: "Contiene la galaxia más cercana a la Vía Láctea.",
    puntos: [
      Offset(0.241, 0.241),
      Offset(0.355, 0.249),
      Offset(0.457, 0.357),
      Offset(0.46, 0.435), // Mirach
      Offset(0.408, 0.51),
      Offset(0.259, 0.418),
      Offset(0.158, 0.4),
      Offset(0.259, 0.418),
      Offset(0.408, 0.51),
      Offset(0.59, 0.585),
      Offset(0.594, 0.703),
      Offset(0.55, 0.752),
      Offset(0.594, 0.703),
      Offset(0.59, 0.585),
      Offset(0.757, 0.608),
      Offset(0.59, 0.585),
      Offset(0.594, 0.518),
      Offset(0.65, 0.4),
      Offset(0.757, 0.284),
      Offset(0.70, 0.27),
      Offset(0.757, 0.284),
      Offset(0.795, 0.229),
    ],
  ),

  Constelacion(
    nombre: "Perseo",
    imagen: "assets/constelaciones/perseo.jpg",
    descripcion:
        "Constelación destacada por las Perseidas, una lluvia de meteoros muy famosa.",
    distancia: "250 – 750 años luz",
    tipo: "Boreal",
    mesesVisibilidad: "Agosto – Marzo",
    significadoNombre: "El héroe que venció a Medusa.",
    formaAprox: "Guerrero",
    hemisferio: "Norte",
    datoCurioso:
        "La estrella Algol es conocida como 'la estrella del demonio'.",
    puntos: [
      Offset(0.658, 0.117),
      Offset(0.49, 0.293),
      Offset(0.40, 0.35),
      Offset(0.275, 0.358),
      Offset(0.253, 0.327),
      Offset(0.238, 0.277),
      Offset(0.296, 0.283),
      Offset(0.352, 0.273),
      Offset(0.296, 0.283),
      Offset(0.238, 0.277),
      Offset(0.253, 0.327),
      Offset(0.275, 0.358),
      Offset(0.40, 0.35),
      Offset(0.49, 0.293),
      Offset(0.565, 0.305),
      Offset(0.68, 0.305),
      Offset(0.565, 0.305),
      Offset(0.49, 0.293),
      Offset(0.554, 0.432),
      Offset(0.553, 0.540),
      Offset(0.58, 0.61),
      Offset(0.553, 0.540),
      Offset(0.554, 0.432),
      Offset(0.49, 0.293),
      Offset(0.379, 0.49),
      Offset(0.302, 0.577),
      Offset(0.278, 0.679),
      Offset(0.31, 0.782),
      Offset(0.372, 0.795),
    ],
  ),

  Constelacion(
    nombre: "Tauro",
    imagen: "assets/constelaciones/tauro.jpg",
    descripcion:
        "Constelación zodiacal conocida por Las Pléyades y la estrella Aldebarán.",
    distancia: "65 – 440 años luz",
    tipo: "Zodiacal",
    mesesVisibilidad: "Noviembre – Marzo",
    significadoNombre: "El toro del Zodiaco.",
    formaAprox: "Cabeza de toro con cuernos",
    hemisferio: "Norte",
    datoCurioso: "Las Pléyades han sido estudiadas desde la antigüedad.",
    puntos: [
      Offset(0.25, 0.178),
      Offset(0.412, 0.358),
      Offset(0.485, 0.463),
      Offset(0.485, 0.514),
      Offset(0.53, 0.51),
      Offset(0.544, 0.57),
      Offset(0.639, 0.647),
      Offset(0.875, 0.735),
      Offset(0.89, 0.773),
      Offset(0.875, 0.735),
      Offset(0.639, 0.647),
      Offset(0.544, 0.57),
      Offset(0.488, 0.568),
      Offset(0.437, 0.557),
      Offset(0.147, 0.373),
    ],
  ),

  Constelacion(
    nombre: "Géminis",
    imagen: "assets/constelaciones/geminis.jpg",
    descripcion:
        "Constelación zodiacal dominada por las estrellas Cástor y Pólux.",
    distancia: "34 – 350 años luz",
    tipo: "Zodiacal",
    mesesVisibilidad: "Diciembre – Abril",
    significadoNombre: "Los gemelos Cástor y Pólux.",
    formaAprox: "Pareja de figuras",
    hemisferio: "Norte",
    datoCurioso:
        "Sus estrellas principales representan a dos hermanos gemelos.",
    puntos: [
      Offset(0.20, 0.15), // Castor
      Offset(0.25, 0.40),
      Offset(0.30, 0.70), // Pie
      Offset(0.25, 0.40),
      Offset(0.65, 0.45), // Brazos unidos
      Offset(0.70, 0.35),
      Offset(0.75, 0.20), // Pollux
      Offset(0.70, 0.35),
      Offset(0.75, 0.75), // Pie Pollux
    ],
  ),

  Constelacion(
    nombre: "Acuario",
    imagen: "assets/constelaciones/acuario.jpg",
    descripcion: "Amplia constelación zodiacal del hemisferio sur celeste.",
    distancia: "160 – 740 años luz",
    tipo: "Zodiacal",
    mesesVisibilidad: "Septiembre – Noviembre",
    significadoNombre: "El portador de agua.",
    formaAprox: "Hombre derramando agua",
    hemisferio: "Sur",
    datoCurioso: "Una de las constelaciones más antiguas documentadas.",
    puntos: [
      Offset(0.20, 0.20),
      Offset(0.35, 0.30), // Hombros
      Offset(0.50, 0.20),
      Offset(0.35, 0.30),
      Offset(0.40, 0.50), // Cuerpo
      Offset(0.30, 0.70), // Flujo de agua 1
      Offset(0.50, 0.80), // Flujo de agua 2
    ],
  ),

  Constelacion(
    nombre: "Capricornio",
    imagen: "assets/constelaciones/capricornio.jpg",
    descripcion:
        "Constelación zodiacal que representa a una criatura mitad pez, mitad cabra.",
    distancia: "150 – 500 años luz",
    tipo: "Zodiacal",
    mesesVisibilidad: "Julio – Octubre",
    significadoNombre: "La cabra marina.",
    formaAprox: "Cabra con cola de pez",
    hemisferio: "Sur",
    datoCurioso: "Una de las constelaciones más débiles del zodiaco.",
    puntos: [
      Offset(0.18, 0.658), // Cuerno
      Offset(0.29, 0.68),
      Offset(0.415, 0.72),
      Offset(0.557, 0.708),
      Offset(0.675, 0.708),
      Offset(0.695, 0.660),
      Offset(0.759, 0.247),
      Offset(0.455, 0.515),
      Offset(0.345, 0.565),
      Offset(0.24, 0.615),
      Offset(0.18, 0.658),
    ],
  ),

  Constelacion(
    nombre: "Sagitario",
    imagen: "assets/constelaciones/sagitario.jpg",
    descripcion:
        "Constelación zodiacal situada en la dirección del centro de la Vía Láctea.",
    distancia: "70 – 800 años luz",
    tipo: "Zodiacal",
    mesesVisibilidad: "Junio – Septiembre",
    significadoNombre: "El arquero centauro.",
    formaAprox: "Arco y flecha",
    hemisferio: "Sur",
    datoCurioso: "Contiene la zona más densa de la Vía Láctea.",
    puntos: [
      Offset(0.238, 0.099),
      Offset(0.345, 0.163),
      Offset(0.40, 0.17),
      Offset(0.454, 0.149),
      Offset(0.40, 0.17),
      Offset(0.46, 0.3),
      Offset(0.54, 0.325),
      Offset(0.643, 0.285),
      Offset(0.71, 0.137),
      Offset(0.643, 0.285),
      Offset(0.7, 0.386),
      Offset(0.793, 0.393),
      Offset(0.925, 0.31),
      Offset(0.793, 0.393),
      Offset(0.7, 0.386),
      Offset(0.673, 0.497),
      Offset(0.728, 0.538),
      Offset(0.673, 0.497),
      Offset(0.7, 0.386),
      Offset(0.643, 0.285),
      Offset(0.54, 0.325),
      Offset(0.443, 0.395),
      Offset(0.403, 0.353),
      Offset(0.227, 0.307),
      Offset(0.117, 0.423),
      Offset(0.083, 0.458),
      Offset(0.204, 0.643),
      Offset(0.269, 0.758),
      Offset(0.381, 0.709),
      Offset(0.269, 0.758),
      Offset(0.419, 0.789),
    ],
  ),
];
