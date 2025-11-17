import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import '../../data/models/constelacion.dart';
import '../../data/models/estrella.dart';
import '../../data/models/coordenadas_celestiales.dart';
import '../../data/models/constelaciones_mock.dart';
import '../widgets/constelacion_painter.dart';

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
    List<Constelacion> constelacionesFiltradas = constelacionesMock;

    if (_constelacionFiltro != "Todas") {
      constelacionesFiltradas = constelacionesMock
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
    final nombres = constelacionesMock.map((c) => c.nombre).toList();
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

