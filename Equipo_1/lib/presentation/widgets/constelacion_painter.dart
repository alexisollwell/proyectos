import 'package:flutter/material.dart';
import '../../data/models/constelacion.dart';
import '../../data/models/estrella.dart';

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
      Canvas canvas, Size size, Offset center, Constelacion constelacion) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Map<int, Offset> starPositions = {};

    bool hasStarsOnScreen = false;

    for (int i = 0; i < constelacion.estrellas.length; i++) {
      final star = constelacion.estrellas[i];
      final pos = _calculateStarPosition(center, constelacion, star);

      if (pos.dx > 0 && pos.dx < size.width && pos.dy > 0 && pos.dy < size.height) {
        starPositions[i] = pos;
        canvas.drawCircle(pos, 3.0 * star.brightness, starPaint);
        hasStarsOnScreen = true;
      }
    }

    for (int i = 0; i < constelacion.estrellas.length; i++) {
      if (!starPositions.containsKey(i)) continue;

      final start = starPositions[i]!;
      final star = constelacion.estrellas[i];

      for (final connIdx in star.connections) {
        if (starPositions.containsKey(connIdx)) {
          canvas.drawLine(start, starPositions[connIdx]!, paint);
        }
      }
    }

    if (hasStarsOnScreen && starPositions.containsKey(0)) {
      _drawText(canvas, constelacion.nombre, starPositions[0]!.translate(10, -20));
    }
  }

  Offset _calculateStarPosition(
      Offset center, Constelacion c, Estrella e) {
    final starAz = c.coordinates.azimuth + (e.x * starCoordinateScale);
    final starAlt = c.coordinates.altitude + (e.y * starCoordinateScale);

    double dAz = starAz - azimuth;
    double dAlt = starAlt - pitch;

    if (dAz > 3.14) dAz -= 6.28;
    if (dAz < -3.14) dAz += 6.28;

    return Offset(
      center.dx + (dAz * scale),
      center.dy - (dAlt * scale),
    );
  }

  void _drawText(Canvas canvas, String text, Offset pos) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 2, offset: Offset(1, 1)),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    painter.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant ConstelacionPainter old) =>
      old.azimuth != azimuth ||
      old.pitch != pitch ||
      old.constelaciones != constelaciones;
}
