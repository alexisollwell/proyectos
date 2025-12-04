import 'package:flutter/material.dart';
import 'dart:ui';

class ConstelacionLineAnimator extends StatefulWidget {
  final List<Offset> puntos;
  final VoidCallback onAnimationEnd;

  const ConstelacionLineAnimator({
    super.key,
    required this.puntos,
    required this.onAnimationEnd,
  });

  @override
  State<ConstelacionLineAnimator> createState() =>
      _ConstelacionLineAnimatorState();
}

class _ConstelacionLineAnimatorState extends State<ConstelacionLineAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Duración del dibujo: 3 segundos
    );

    _progressAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Iniciar la animación y llamar al callback cuando termine
    _controller.forward().then((_) => widget.onAnimationEnd());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si no hay puntos, no dibujamos nada
    if (widget.puntos.isEmpty) return const SizedBox();

    return AnimatedBuilder(
      animation: _progressAnim,
      builder: (context, child) {
        return CustomPaint(
          painter: _LineasPainter(
            puntos: widget.puntos,
            progreso: _progressAnim.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _LineasPainter extends CustomPainter {
  final List<Offset> puntos;
  final double progreso;

  _LineasPainter({required this.puntos, required this.progreso});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Configuración de Pinceles

    // Línea azul neón (tipo "Tron" o Sci-Fi)
    final paintLineas = Paint()
      ..color =
          const Color(0xFF64FFDA) // Cyan brillante
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Puntos (Estrellas)
    final paintPuntos = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Brillo alrededor de las estrellas
    final paintBrillo = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    if (puntos.isEmpty) return;

    int totalSegmentos = puntos.length - 1;

    // 2. Dibujar Estrellas (Siempre visibles, o podrías hacer que aparezcan progresivamente)
    for (var punto in puntos) {
      // Convertir coordenada relativa (0.0 - 1.0) a pixeles reales
      final offset = Offset(punto.dx * size.width, punto.dy * size.height);

      canvas.drawCircle(offset, 6, paintBrillo); // Glow
      canvas.drawCircle(offset, 3, paintPuntos); // Centro
    }

    // 3. Dibujar Líneas Progresivas
    if (totalSegmentos > 0) {
      double rutaVisible = progreso * totalSegmentos;

      for (int i = 0; i < totalSegmentos; i++) {
        if (rutaVisible > i) {
          final p1 = Offset(
            puntos[i].dx * size.width,
            puntos[i].dy * size.height,
          );
          final p2 = Offset(
            puntos[i + 1].dx * size.width,
            puntos[i + 1].dy * size.height,
          );

          if (rutaVisible < i + 1) {
            // Estamos en el segmento actual (dibujándose)
            double porcentajeSegmento = rutaVisible - i;
            final pDestino = Offset.lerp(p1, p2, porcentajeSegmento)!;
            canvas.drawLine(p1, pDestino, paintLineas);
          } else {
            // Segmento completado
            canvas.drawLine(p1, p2, paintLineas);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LineasPainter oldDelegate) {
    return oldDelegate.progreso != progreso;
  }
}
