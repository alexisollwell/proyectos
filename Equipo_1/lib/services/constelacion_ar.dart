import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class ConstelacionARPage extends StatefulWidget {
  const ConstelacionARPage({super.key});

  @override
  State<ConstelacionARPage> createState() => _ConstelacionARPageState();
}

class _ConstelacionARPageState extends State<ConstelacionARPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  double _azimuth = 0.0; 
  double _pitch = 0.0;
  double _roll = 0.0;
  Position? _currentPosition;
  String _constelacionFiltro = "Todas";

  final double _fovHorizontal = pi / 3;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startSensors(); 
    _getCurrentLocation();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _controller!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error inicializando cámara: $e');
    }
  }

  void _startSensors() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _pitch = atan2(event.z, -event.y);
        _roll = atan2(event.x, -event.y);
      });
    });
    magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        double azimuthRad = atan2(event.y, event.x);

        if (azimuthRad < 0) {
          azimuthRad += 2 * pi;
        }

        _azimuth = azimuthRad;
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error obteniendo ubicación: $e');
    }
  }

  List<Constelacion> _getVisibleConstellations() {
    List<Constelacion> constelacionesFiltradas = _constelaciones;

    if (_constelacionFiltro != "Todas") {
      constelacionesFiltradas = _constelaciones
          .where((constelacion) => constelacion.nombre == _constelacionFiltro)
          .toList();
    }
    return constelacionesFiltradas;
  }
  bool _esConstelacionVisible(Constelacion constelacion) {
    final fovHorizontal = _fovHorizontal * 1.5;
    final fovVertical = (pi / 4) * 1.5;

    double diferenciaAzimuth = (_azimuth - constelacion.coordinates.azimuth)
        .abs();
    if (diferenciaAzimuth > pi) {
      diferenciaAzimuth = (2 * pi) - diferenciaAzimuth;
    }

    final diferenciaAltitud = (_pitch - constelacion.coordinates.altitude)
        .abs();

    return diferenciaAzimuth < (fovHorizontal / 2) &&
        diferenciaAltitud < (fovVertical / 2);
  }

  List<String> _getNombresConstelaciones() {
    final nombres = _constelaciones.map((c) => c.nombre).toList();
    nombres.insert(0, "Todas");
    return nombres;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isCameraInitialized) CameraPreview(_controller!),
          _buildConstellationsOverlay(), 
          _buildControls(),
          _buildConstellationSelector(),
          _buildDebugInfo(),
        ],
      ),
    );
  }

  Widget _buildConstellationsOverlay() {
    final constelacionesVisibles = _getVisibleConstellations();
    final screenWidth = MediaQuery.of(context).size.width;

    final double scale = screenWidth / _fovHorizontal;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: ConstelacionPainter(
          constelaciones: constelacionesVisibles,
          azimuth: _azimuth,
          pitch: _pitch,
          scale: scale, 
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const Text(
            "Constelaciones AR",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(width: 40),
        ],
      ),
    );
  }

  Widget _buildConstellationSelector() {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _getNombresConstelaciones().length,
          itemBuilder: (context, index) {
            final nombre = _getNombresConstelaciones()[index];
            final isSelected = _constelacionFiltro == nombre;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _constelacionFiltro = nombre;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Center(
                  child: Text(
                    nombre,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDebugInfo() {
    return Positioned(
      bottom: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(
              'Az: ${(_azimuth * 180 / pi).toStringAsFixed(1)}°',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Pt: ${(_pitch * 180 / pi).toStringAsFixed(1)}°',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Rl: ${(_roll * 180 / pi).toStringAsFixed(1)}°',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Filtro: $_constelacionFiltro',
              style: const TextStyle(color: Colors.yellow, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
class ConstelacionPainter extends CustomPainter {
  final List<Constelacion> constelaciones;
  final double azimuth;
  final double pitch;
  final double scale; 
  final double starCoordinateScale = 0.05;

  ConstelacionPainter({
    required this.constelaciones,
    required this.azimuth,
    required this.pitch,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final constelacion in constelaciones) {
      _paintConstellation(canvas, size, center, constelacion);
    }
  }

  void _paintConstellation(
    Canvas canvas,
    Size size,
    Offset center,
    Constelacion constelacion,
  ) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Map<int, Offset> starPositions = {};
    bool isAnyStarOnScreen = false;
    for (int i = 0; i < constelacion.estrellas.length; i++) {
      final estrella = constelacion.estrellas[i];

      final posicion = _calculateStarPosition(center, constelacion, estrella);

      if (posicion.dx > 0 &&
          posicion.dx < size.width &&
          posicion.dy > 0 &&
          posicion.dy < size.height) {
        starPositions[i] = posicion;
        canvas.drawCircle(posicion, 3.0 * estrella.brightness, starPaint);
        isAnyStarOnScreen = true;
      }
    }
    for (int i = 0; i < constelacion.estrellas.length; i++) {
      if (starPositions.containsKey(i)) {
        final startPos = starPositions[i]!;
        final estrella = constelacion.estrellas[i];

        for (final connectedIndex in estrella.connections) {
          if (starPositions.containsKey(connectedIndex)) {
            final connectedPos = starPositions[connectedIndex]!;
            canvas.drawLine(startPos, connectedPos, paint);
          }
        }
      }
    }
    if (isAnyStarOnScreen && starPositions.containsKey(0)) {
      _drawText(
        canvas,
        constelacion.nombre,
        starPositions[0]!.translate(10, -20),
      );
    }
  }

  Offset _calculateStarPosition(
    Offset center,
    Constelacion constelacion,
    Estrella estrella,
  ) {
    final double starAz =
        constelacion.coordinates.azimuth + (estrella.x * starCoordinateScale);
    final double starAlt =
        constelacion.coordinates.altitude + (estrella.y * starCoordinateScale);
    double deltaAz = starAz - azimuth;
    double deltaAlt = starAlt - pitch; 
    if (deltaAz > pi) deltaAz -= 2 * pi;
    if (deltaAz < -pi) deltaAz += 2 * pi;
    final x = center.dx + (deltaAz * scale);
    final y = center.dy - (deltaAlt * scale); 

    return Offset(x, y);
  }

  void _drawText(Canvas canvas, String text, Offset position) {
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(color: Colors.black, blurRadius: 2, offset: Offset(1, 1)),
      ],
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant ConstelacionPainter oldDelegate) =>
      oldDelegate.azimuth != azimuth ||
      oldDelegate.pitch != pitch ||
      oldDelegate.constelaciones != constelaciones;
}

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

class Estrella {
  final double x;
  final double y;
  final double brightness;
  final List<int> connections;

  Estrella({
    required this.x,
    required this.y,
    required this.brightness,
    required this.connections,
  });
}

class CoordenadasCelestiales {
  final double altitude; 
  final double azimuth; 

  CoordenadasCelestiales({required this.altitude, required this.azimuth});
}

final _constelaciones = [
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
