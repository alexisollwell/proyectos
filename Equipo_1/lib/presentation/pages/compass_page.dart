import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

class CompassPage extends StatefulWidget {
  const CompassPage({super.key});

  @override
  State<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  double? _lastDirection;
  double _smoothDirection = 0.0;
  DateTime? _lastUpdate;
  bool _isLocked = false;
  double _lockedDirection = 0.0;
  final List<String> _direcciones = [
    "N",
    "NE",
    "E",
    "SE",
    "S",
    "SW",
    "W",
    "NW",
  ];

  final Color _primaryColor = Color.fromARGB(255, 55, 66, 137);
  final Color _secondaryColor = Color.fromARGB(255, 161, 167, 254);
  final Color _cardColor = Color.fromARGB(255, 231, 243, 251);
  final Color _accentColor = Color.fromARGB(255, 77, 84, 209);
  final Color _lockedColor = const Color.fromARGB(255, 70, 20, 110);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cardColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: _primaryColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Brújula Digital",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isLocked)
                          Text(
                            "DIRECCIÓN BLOQUEADA",
                            style: TextStyle(
                              color: _lockedColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder<double?>(
                stream: FlutterCompass.events?.map((event) => event.heading),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildErrorState();
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return _buildLoadingState();
                  }

                  double direction = snapshot.data!;

                  if (!_isLocked) {
                    _smoothDirection = _applySmoothing(direction);
                    _lastUpdate = DateTime.now();
                  }

                  final displayDirection = _isLocked
                      ? _lockedDirection
                      : _smoothDirection;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCompass(displayDirection),

                      _buildCompassInfo(displayDirection),

                      _buildActionButtons(),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCompass(double direction) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _secondaryColor,
            border: Border.all(
              color: _isLocked ? _lockedColor : _primaryColor.withOpacity(0.3),
              width: _isLocked ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: (_isLocked ? _lockedColor : _primaryColor).withOpacity(
                  0.15,
                ),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildDegreeMarks(),

              Transform.rotate(
                angle: (direction * (math.pi / 180) * -1),
                child: Image.asset(
                  "assets/compass.png",
                  height: 200,
                  color: _isLocked ? _lockedColor : _primaryColor,
                ),
              ),

              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isLocked ? _lockedColor : _primaryColor,
                ),
              ),
            ],
          ),
        ),

        if (_isLocked)
          Positioned(
            top: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: _lockedColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock, color: Colors.white, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    "BLOQUEADO",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDegreeMarks() {
    return SizedBox(
      width: 240,
      height: 240,
      child: CustomPaint(
        painter: DegreeMarksPainter(
          color: _isLocked ? _lockedColor : _primaryColor,
        ),
      ),
    );
  }

  Widget _buildCompassInfo(double direction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _secondaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(
                icon: Icons.navigation,
                title: "Dirección",
                value: '${direction.toStringAsFixed(1)}°',
                color: _isLocked ? _lockedColor : _primaryColor,
              ),
              _buildInfoItem(
                icon: Icons.explore,
                title: "Cardinal",
                value: _getCardinalDirection(direction),
                color: _accentColor,
              ),
              _buildInfoItem(
                icon: Icons.access_time,
                title: "Actualizado",
                value: _getLastUpdateTime(),
                color: Colors.green,
              ),
            ],
          ),

          if (_isLocked)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _lockedColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _lockedColor, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info, color: _lockedColor, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      "Dirección fijada en ${_lockedDirection.toStringAsFixed(1)}°",
                      style: TextStyle(
                        color: _lockedColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(color: _primaryColor, fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _calibrateCompass,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
            ),
            icon: const Icon(Icons.compass_calibration, size: 18),
            label: const Text("Calibrar"),
          ),
          ElevatedButton.icon(
            onPressed: _toggleLock,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isLocked ? _lockedColor : _accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
            ),
            icon: Icon(_isLocked ? Icons.lock_open : Icons.lock, size: 18),
            label: Text(_isLocked ? "Desbloquear" : "Bloquear"),
          ),
        ],
      ),
    );
  }

  void _toggleLock() {
    setState(() {
      if (_isLocked) {
        _isLocked = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: _accentColor,
            content: const Text("Brújula desbloqueada - Funcionamiento normal"),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        _isLocked = true;
        _lockedDirection = _smoothDirection;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: _lockedColor,
            content: Text(
              "Dirección bloqueada en ${_lockedDirection.toStringAsFixed(1)}°",
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: _primaryColor),
          const SizedBox(height: 20),
          Text(
            "Inicializando brújula...",
            style: TextStyle(color: _primaryColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 16),
            Text(
              "Sensor no disponible",
              style: TextStyle(
                color: _primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Tu dispositivo no tiene sensor de brújula\no no se han concedido los permisos.",
              textAlign: TextAlign.center,
              style: TextStyle(color: _accentColor, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() {}),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text("Reintentar"),
            ),
          ],
        ),
      ),
    );
  }

  // Métodos auxiliares
  String _getCardinalDirection(double degrees) {
    const sectors = 45.0;
    int index = ((degrees + sectors / 2) % 360) ~/ sectors;
    return _direcciones[index];
  }

  double _applySmoothing(double newDirection) {
    if (_lastDirection == null) return newDirection;

    double diff = newDirection - _lastDirection!;
    if (diff.abs() > 180) {
      if (diff > 0) {
        diff -= 360;
      } else {
        diff += 360;
      }
    }

    _lastDirection = _lastDirection! + diff * 0.3;
    return _lastDirection!;
  }

  String _getLastUpdateTime() {
    if (_lastUpdate == null) return "Ahora";

    final now = DateTime.now();
    final diff = now.difference(_lastUpdate!);

    if (diff.inSeconds < 10) return "Ahora";
    if (diff.inSeconds < 60) return "${diff.inSeconds}s";
    return "${diff.inMinutes}m";
  }

  void _calibrateCompass() {
    if (_isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _lockedColor,
          content: const Text("Desbloquea la brújula para calibrar"),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _primaryColor,
        content: const Text(
          "Calibrando brújula... Mueve tu dispositivo en forma de 8",
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class DegreeMarksPainter extends CustomPainter {
  final Color color;

  DegreeMarksPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 15;

    for (int i = 0; i < 360; i += 30) {
      final angle = i * math.pi / 180;
      final start = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final end = Offset(
        center.dx + (radius - 12) * math.cos(angle),
        center.dy + (radius - 12) * math.sin(angle),
      );

      canvas.drawLine(start, end, paint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final textOffset = Offset(
        center.dx + (radius - 25) * math.cos(angle) - textPainter.width / 2,
        center.dy + (radius - 25) * math.sin(angle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
