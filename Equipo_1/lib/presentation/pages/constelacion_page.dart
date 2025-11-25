import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import '../../data/models/constelacion.dart';
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
  // ignore: unused_field
  double _roll = 0.0;
  // ignore: unused_field
  Position? _currentPosition;
  String _constelacionActual = "Osa Mayor";
  // ignore: prefer_final_fields
  List<Constelacion> _constelacionesFijadas = [];
  bool _modoFijacion = false;
  // ignore: unused_field
  Constelacion? _constelacionParaFijar;

  final double _fovHorizontal = pi / 3;
  final double _fovVertical = pi / 4;

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
      // ignore: avoid_print
      print('Error inicializando cámara: $e');
    }
  }

  void _startSensors() {
    // ignore: deprecated_member_use
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _pitch = atan2(event.z, -event.y);
        _roll = atan2(event.x, -event.y);
      });
    });

    // ignore: deprecated_member_use
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
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error obteniendo ubicación: $e');
    }
  }

  Constelacion _getConstelacionActual() {
    final constelacionBase = constelacionesMock.firstWhere(
      (c) => c.nombre == _constelacionActual,
      orElse: () => constelacionesMock.first,
    );

    final constelacionFijada = _constelacionesFijadas
        .where((c) => c.nombre == _constelacionActual)
        .firstOrNull;

    return constelacionFijada ?? constelacionBase;
  }

  List<Constelacion> _getConstelacionesVisibles() {
    final constelaciones = [..._constelacionesFijadas];

    final constelacionActual = _getConstelacionActual();
    if (!_constelacionesFijadas.any((c) => c.nombre == _constelacionActual)) {
      constelaciones.add(constelacionActual);
    }

    return constelaciones;
  }

  bool _estaEnCampoVision(Constelacion constelacion) {
    final coord = constelacion.coordinates;
    final altitud = coord.currentAltitude;
    final azimuth = coord.currentAzimuth;

    double diffAzimuth = (_azimuth - azimuth).abs();
    if (diffAzimuth > pi) {
      diffAzimuth = (2 * pi) - diffAzimuth;
    }

    final diffAltitud = (_pitch - altitud).abs();

    return diffAzimuth < (_fovHorizontal / 2) &&
        diffAltitud < (_fovVertical / 2);
  }

  void _fijarConstelacionActual() {
    final constelacionBase = constelacionesMock.firstWhere(
      (c) => c.nombre == _constelacionActual,
    );

    final constelacionFijada = constelacionBase.copyWith(
      isFixed: true,
      fixedAltitude: _pitch,
      fixedAzimuth: _azimuth,
    );

    setState(() {
      _constelacionesFijadas.add(constelacionFijada);
      _modoFijacion = false;
      _constelacionParaFijar = null;
    });
  }

  void _liberarConstelacion(String nombre) {
    setState(() {
      _constelacionesFijadas.removeWhere((c) => c.nombre == nombre);
    });
  }

  void _iniciarModoFijacion() {
    setState(() {
      _modoFijacion = true;
      _constelacionParaFijar = _getConstelacionActual();
    });
  }

  void _cancelarModoFijacion() {
    setState(() {
      _modoFijacion = false;
      _constelacionParaFijar = null;
    });
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
          if (_isCameraInitialized)
            SizedBox.expand(child: CameraPreview(_controller!)),

          _buildConstellationsOverlay(),
          _buildMainControls(),
          _buildConstellationSelector(),
          _buildDebugInfo(),
          _buildModoFijacionUI(),
        ],
      ),
    );
  }

  Widget _buildConstellationsOverlay() {
    final constelacionesVisibles = _getConstelacionesVisibles();
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / _fovHorizontal;

    return SizedBox.expand(
      child: CustomPaint(
        painter: ConstelacionPainter(
          constelaciones: constelacionesVisibles,
          azimuth: _azimuth,
          pitch: _pitch,
          scale: scale,
          fovHorizontal: _fovHorizontal,
          fovVertical: _fovVertical,
          onConstelacionTap: _liberarConstelacion,
        ),
      ),
    );
  }

  Widget _buildMainControls() {
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

          Column(
            children: [
              const Text(
                "Constelaciones AR",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_constelacionesFijadas.isNotEmpty)
                Text(
                  '${_constelacionesFijadas.length} fijadas',
                  style: const TextStyle(fontSize: 12, color: Colors.yellow),
                ),
            ],
          ),

          if (!_modoFijacion && !_getConstelacionActual().isFixed)
            GestureDetector(
              onTap: _iniciarModoFijacion,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.push_pin,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildConstellationSelector() {
    final nombres = constelacionesMock.map((c) => c.nombre).toList();

    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: nombres.length,
          itemBuilder: (context, index) {
            final nombre = nombres[index];
            final isSelected = _constelacionActual == nombre;
            final isFixed = _constelacionesFijadas.any(
              (c) => c.nombre == nombre,
            );

            return GestureDetector(
              onTap: () {
                setState(() {
                  _constelacionActual = nombre;
                  _modoFijacion = false;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue
                      : isFixed
                      ? Colors.green
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isFixed ? Colors.green : Colors.white,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      nombre,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (isFixed) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.push_pin, size: 12, color: Colors.white),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModoFijacionUI() {
    if (!_modoFijacion) return const SizedBox();

    return Positioned(
      bottom: 160,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.blue.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              // ignore: unnecessary_brace_in_string_interps
              'Fijar ${_constelacionActual} en posición actual',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Apunta al lugar donde quieres fijar la constelación\nLuego presiona "Confirmar"',
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _cancelarModoFijacion,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _fijarConstelacionActual,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Confirmar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugInfo() {
    final constelacionActual = _getConstelacionActual();
    final estaEnVision = _estaEnCampoVision(constelacionActual);

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
              'Const: ${constelacionActual.nombre}',
              style: TextStyle(
                color: constelacionActual.isFixed ? Colors.green : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Az: ${(_azimuth * 180 / pi).toStringAsFixed(1)}°',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            Text(
              'Alt: ${(_pitch * 180 / pi).toStringAsFixed(1)}°',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            Text(
              'Visión: ${estaEnVision ? 'DENTRO' : 'FUERA'}',
              style: TextStyle(
                color: estaEnVision ? Colors.green : Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Fijadas: ${_constelacionesFijadas.length}',
              style: const TextStyle(color: Colors.yellow, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
