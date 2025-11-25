import 'dart:math';

import 'package:flutter/material.dart';
import '../../data/models/constelacion.dart';
import '../../data/models/estrella.dart';

class ConstelacionPainter extends CustomPainter {
  final List<Constelacion> constelaciones;
  final double azimuth;
  final double pitch;
  final double scale;
  final double fovHorizontal;
  final double fovVertical;
  final Function(String)? onConstelacionTap;

  ConstelacionPainter({
    required this.constelaciones,
    required this.azimuth,
    required this.pitch,
    required this.scale,
    required this.fovHorizontal,
    required this.fovVertical,
    this.onConstelacionTap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final constelacion in constelaciones) {
      if (_estaEnCampoVision(constelacion)) {
        _paintConstellation(canvas, size, center, constelacion);
      }
    }
  }

  bool _estaEnCampoVision(Constelacion constelacion) {
    final coord = constelacion.coordinates;
    final altitud = coord.currentAltitude;
    final azimuthConst = coord.currentAzimuth;

    double diffAzimuth = (azimuth - azimuthConst).abs();
    if (diffAzimuth > pi) {
      diffAzimuth = (2 * pi) - diffAzimuth;
    }

    final diffAltitud = (pitch - altitud).abs();

    return diffAzimuth < (fovHorizontal / 2) && diffAltitud < (fovVertical / 2);
  }

  void _paintConstellation(
    Canvas canvas,
    Size size,
    Offset center,
    Constelacion constelacion,
  ) {
    final isFixed = constelacion.isFixed;

    // ignore: deprecated_member_use
    final lineColor = isFixed ? Colors.green : Colors.yellow.withOpacity(0.8);
    final starColor = isFixed ? Colors.green : Colors.white;

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = isFixed ? 2.5 : 2.0;

    final starPaint = Paint()
      ..color = starColor
      ..style = PaintingStyle.fill;

    final Map<int, Offset> starPositions = {};
    final posicionConstelacion = _calculateConstellationPosition(
      center,
      constelacion,
    );

    for (int i = 0; i < constelacion.estrellas.length; i++) {
      final star = constelacion.estrellas[i];
      final pos = _calculateStarPosition(posicionConstelacion, star);
      starPositions[i] = pos;
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

    for (int i = 0; i < constelacion.estrellas.length; i++) {
      if (!starPositions.containsKey(i)) continue;

      final star = constelacion.estrellas[i];
      final pos = starPositions[i]!;

      final radius = (isFixed ? 3.5 : 3.0) * star.brightness;
      canvas.drawCircle(pos, radius, starPaint);

      if (isFixed) {
        final ringPaint = Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawCircle(pos, radius + 1.0, ringPaint);
      }
    }

    if (starPositions.containsKey(0)) {
      _drawText(
        canvas,
        constelacion.nombre,
        starPositions[0]!.translate(10, -20),
        isFixed: isFixed,
      );
    }

    if (isFixed && !_estaCompletamenteEnPantalla(starPositions, size)) {
      _drawOffScreenIndicator(canvas, size, center, constelacion);
    }
  }

  Offset _calculateConstellationPosition(
    Offset center,
    Constelacion constelacion,
  ) {
    final coord = constelacion.coordinates;
    final altitud = coord.currentAltitude;
    final azimuthConst = coord.currentAzimuth;

    final dAz = azimuthConst - azimuth;
    final dAlt = altitud - pitch;

    return Offset(center.dx + (dAz * scale), center.dy - (dAlt * scale));
  }

  Offset _calculateStarPosition(Offset constellationCenter, Estrella star) {
    return Offset(
      constellationCenter.dx + (star.x * 40),
      constellationCenter.dy + (star.y * 40),
    );
  }

  bool _estaCompletamenteEnPantalla(Map<int, Offset> positions, Size size) {
    for (final position in positions.values) {
      if (position.dx < 0 ||
          position.dx > size.width ||
          position.dy < 0 ||
          position.dy > size.height) {
        return false;
      }
    }
    return true;
  }

  void _drawOffScreenIndicator(
    Canvas canvas,
    Size size,
    Offset center,
    Constelacion constelacion,
  ) {
    final coord = constelacion.coordinates;
    final altitud = coord.currentAltitude;
    final azimuthConst = coord.currentAzimuth;
    final dAz = azimuthConst - azimuth;
    final dAlt = altitud - pitch;
    final magnitude = sqrt(dAz * dAz + dAlt * dAlt);
    final dirX = dAz / magnitude;
    final dirY = -dAlt / magnitude;
    final screenEdge = _calculateScreenEdgePosition(size, center, dirX, dirY);

    final indicatorPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    canvas.drawCircle(screenEdge, 6, indicatorPaint);

    final linePaint = Paint()
      // ignore: deprecated_member_use
      ..color = Colors.green.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawLine(center, screenEdge, linePaint);
  }

  Offset _calculateScreenEdgePosition(
    Size size,
    Offset center,
    double dirX,
    double dirY,
  ) {
    final halfWidth = size.width / 2;
    final halfHeight = size.height / 2;
    final distToRight = (halfWidth - center.dx) / dirX;
    final distToLeft = (-halfWidth - center.dx) / dirX;
    final distToBottom = (halfHeight - center.dy) / dirY;
    final distToTop = (-halfHeight - center.dy) / dirY;
    double minDist = double.infinity;
    if (distToRight > 0 && distToRight < minDist) minDist = distToRight;
    if (distToLeft > 0 && distToLeft < minDist) minDist = distToLeft;
    if (distToBottom > 0 && distToBottom < minDist) minDist = distToBottom;
    if (distToTop > 0 && distToTop < minDist) minDist = distToTop;

    return Offset(center.dx + dirX * minDist, center.dy + dirY * minDist);
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset pos, {
    bool isFixed = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isFixed ? Colors.green : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          shadows: const [
            Shadow(color: Colors.black, blurRadius: 3, offset: Offset(1, 1)),
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
