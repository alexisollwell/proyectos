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
        _pitch = event.x;
        _roll = event.y;
      });
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _azimuth = event.z;
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
    return _constelaciones.where((constelacion) {
      return _esConstelacionVisible(constelacion);
    }).toList();
  }

  bool _esConstelacionVisible(Constelacion constelacion) {
    final diferenciaAzimuth = (_azimuth - constelacion.coordinates.azimuth)
        .abs();
    final diferenciaAltitud = (_pitch - constelacion.coordinates.altitude)
        .abs();

    return diferenciaAzimuth < 1.0 && diferenciaAltitud < 0.8;
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
          _buildDebugInfo(),
        ],
      ),
    );
  }

  Widget _buildConstellationsOverlay() {
    final constelacionesVisibles = _getVisibleConstellations();

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: ConstelacionPainter(
          constelaciones: constelacionesVisibles,
          azimuth: _azimuth,
          pitch: _pitch,
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
        child: Text(
          'Az: ${_azimuth.toStringAsFixed(2)}\n'
          'Pt: ${_pitch.toStringAsFixed(2)}\n'
          'Rl: ${_roll.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

class ConstelacionPainter extends CustomPainter {
  final List<Constelacion> constelaciones;
  final double azimuth;
  final double pitch;

  ConstelacionPainter({
    required this.constelaciones,
    required this.azimuth,
    required this.pitch,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final constelacion in constelaciones) {
      _paintConstellation(canvas, center, constelacion);
    }
  }

  void _paintConstellation(
    Canvas canvas,
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

    for (final estrella in constelacion.estrellas) {
      final posicion = _calculateStarPosition(center, estrella);

      canvas.drawCircle(posicion, 3.0 * estrella.brightness, starPaint);

      for (final connectedIndex in estrella.connections) {
        if (connectedIndex < constelacion.estrellas.length) {
          final connectedStar = constelacion.estrellas[connectedIndex];
          final connectedPos = _calculateStarPosition(center, connectedStar);
          canvas.drawLine(posicion, connectedPos, paint);
        }
      }
    }

    if (constelacion.estrellas.isNotEmpty) {
      final nombrePosicion = _calculateStarPosition(
        center,
        constelacion.estrellas[0],
      );
      _drawText(canvas, constelacion.nombre, nombrePosicion);
    }
  }

  Offset _calculateStarPosition(Offset center, Estrella estrella) {
    final scale = 50.0;
    final x =
        center.dx +
        (estrella.x * cos(azimuth) - estrella.y * sin(azimuth)) * scale;
    final y =
        center.dy +
        (estrella.x * sin(azimuth) + estrella.y * cos(azimuth)) * scale;
    return Offset(x, y);
  }

  void _drawText(Canvas canvas, String text, Offset position) {
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, position.translate(10, -20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
];
