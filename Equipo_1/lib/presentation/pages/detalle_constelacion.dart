import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyectos/data/models/constelacion_model.dart';
import 'package:proyectos/presentation/pages/constelacion_page.dart';
import 'package:proyectos/presentation/widgets/constelation_line_animator.dart';

class DetalleConstelacionPage extends StatefulWidget {
  final Constelacion constelacion;
  const DetalleConstelacionPage({super.key, required this.constelacion});

  @override
  State<DetalleConstelacionPage> createState() =>
      _DetalleConstelacionPageState();
}

class _DetalleConstelacionPageState extends State<DetalleConstelacionPage>
    with TickerProviderStateMixin {
  late final AnimationController _cardCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final AnimationController _imageFadeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  late final Animation<Offset> _slideAnim = Tween<Offset>(
    begin: const Offset(0, 0.15),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut));

  late final Animation<double> _fadeAnim = CurvedAnimation(
    parent: _cardCtrl,
    curve: Curves.easeIn,
  );

  // ignore: unused_field
  bool _drawingFinished = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _cardCtrl.forward();
    });
    if (widget.constelacion.puntos.isEmpty) {
      _drawingFinished = true;
      _imageFadeCtrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _cardCtrl.dispose();
    _imageFadeCtrl.dispose();
    super.dispose();
  }

  Widget _infoRow(String title, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 55, 66, 137),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Color.fromARGB(255, 55, 66, 137)),
          ),
        ),
      ],
    ),
  );

  Widget _buildInfoCard(Constelacion c) => SlideTransition(
    position: _slideAnim,
    child: FadeTransition(
      opacity: _fadeAnim,
      child: Card(
        elevation: 6,
        color: const Color.fromARGB(255, 180, 200, 236),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.nombre,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 55, 66, 137),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                c.descripcion,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Color.fromARGB(255, 55, 66, 137),
                ),
              ),
              const SizedBox(height: 16),
              _infoRow("Distancia aproximada", c.distancia),
              _infoRow("Tipo", c.tipo),
              _infoRow("Meses de visibilidad", c.mesesVisibilidad),
              _infoRow("Significado del nombre", c.significadoNombre),
              _infoRow("Forma aproximada", c.formaAprox),
              _infoRow("Hemisferio", c.hemisferio),
              _infoRow("Dato curioso", c.datoCurioso),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final c = widget.constelacion;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(c.nombre),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 116),
        children: [
          Hero(
            tag: 'constelacion-${c.nombre}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: Colors.black),

                    ConstelacionLineAnimator(
                      puntos: c.puntos,
                      onAnimationEnd: () {
                        if (mounted) {
                          setState(() {
                            _drawingFinished = true;
                          });
                          _imageFadeCtrl.forward();
                        }
                      },
                    ),

                    FadeTransition(
                      opacity: _imageFadeCtrl,
                      child: Image.asset(c.imagen, fit: BoxFit.cover),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),
          _buildInfoCard(c),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 60,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ConstelacionARPage()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 161, 167, 254),
              foregroundColor: const Color.fromARGB(255, 55, 66, 137),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const FaIcon(FontAwesomeIcons.camera, size: 20),
            label: const Text('Realidad Aumentada'),
          ),
        ),
      ),
    );
  }
}
