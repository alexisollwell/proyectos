import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyectos/data/services/spacex_service.dart';
import 'package:proyectos/data/models/spacex_model.dart';
import 'package:proyectos/presentation/helpers/constelacion_ui.dart';

class PaginaConstelacion extends StatefulWidget {
  const PaginaConstelacion({super.key});

  @override
  State<PaginaConstelacion> createState() => _PaginaConstelacionState();
}

class _PaginaConstelacionState extends State<PaginaConstelacion> {
  late Future<List<Constelacion>> _planetasFuture;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _planetasFuture = _cargarPlanetas();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<Constelacion>> _cargarPlanetas() async {
    return await ConstellationService.obtenerTodosLosPlanetas();
  }

  Future<void> _recargarPlanetas() async {
    setState(() {
      _planetasFuture = _cargarPlanetas();
      _currentPage = 0;
      _pageController.jumpToPage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 243, 251),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FutureBuilder<List<Constelacion>>(
                  future: _planetasFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingState();
                    }

                    if (snapshot.hasError) {
                      return _buildErrorState(snapshot.error.toString());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildErrorState(
                        'No se recibieron datos de cuerpos celestes',
                      );
                    }

                    final planetas = snapshot.data!;
                    return _buildCarruselContent(planetas);
                  },
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 161, 167, 254),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color.fromARGB(255, 55, 66, 137),
                size: 20,
              ),
            ),
          ),
          Text(
            "SISTEMA SOLAR",
            style: GoogleFonts.bebasNeue(
              fontSize: 24,
              color: const Color.fromARGB(255, 69, 55, 137),
            ),
          ),
          Container(width: 44),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 212, 220, 240),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Column(
            children: [
              CircularProgressIndicator(
                color: Color.fromARGB(255, 55, 66, 137),
              ),
              SizedBox(height: 16),
              Text(
                "Consultando Astronomy API...",
                style: TextStyle(
                  color: Color.fromARGB(255, 55, 66, 137),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Cargando información del Sistema Solar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 55, 66, 137),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 212, 220, 240),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              const FaIcon(
                FontAwesomeIcons.satelliteDish,
                color: Color.fromARGB(255, 55, 66, 137),
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                "Error al cargar datos",
                style: TextStyle(
                  color: Color.fromARGB(255, 55, 66, 137),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 235, 238),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromARGB(255, 244, 67, 54),
                    width: 1,
                  ),
                ),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 55, 66, 137),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _recargarPlanetas,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 55, 66, 137),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarruselContent(List<Constelacion> planetas) {
    return Column(
      children: [
        _buildPageIndicator(planetas.length),
        Expanded(
          flex: 3,
          child: PageView.builder(
            controller: _pageController,
            itemCount: planetas.length,
            itemBuilder: (context, index) {
              return _buildPlanetaCard(planetas[index], index);
            },
          ),
        ),

        Expanded(flex: 2, child: _buildDetallePlaneta(planetas[_currentPage])),
      ],
    );
  }

  Widget _buildPageIndicator(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index
                  ? const Color.fromARGB(255, 55, 66, 137)
                  // ignore: deprecated_member_use
                  : Colors.grey.withOpacity(0.5),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPlanetaCard(Constelacion planeta, int index) {
    final isCurrent = index == _currentPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 161, 167, 254),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(isCurrent ? 0.3 : 0.1),
            blurRadius: isCurrent ? 10 : 5,
            offset: Offset(0, isCurrent ? 5 : 2),
          ),
        ],
        border: isCurrent
            ? Border.all(
                color: const Color.fromARGB(255, 55, 66, 137),
                width: 2,
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: ConstelacionUI.colorTipo(planeta).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              ConstelacionUI.iconoPlaneta(planeta),
              size: 40,
              color: ConstelacionUI.colorTipo(planeta),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            planeta.nombreSoloEspanol,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 55, 66, 137),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 5),
          Text(
            planeta.nombreSoloIngles,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 77, 84, 209),
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                ConstelacionUI.iconoVisibilidad(planeta),
                color: ConstelacionUI.colorVisibilidad(planeta),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                planeta.visibilidad,
                style: TextStyle(
                  color: ConstelacionUI.colorVisibilidad(planeta),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetallePlaneta(Constelacion planeta) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 180, 200, 236),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Información de ${planeta.nombreSoloEspanol}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 55, 66, 137),
              ),
            ),
            const SizedBox(height: 15),

            _buildInfoDetalle(
              icon: FontAwesomeIcons.clock,
              title: "Mejor Horario",
              value: planeta.mejorhorario,
            ),

            _buildInfoDetalle(
              icon: FontAwesomeIcons.users,
              title: "Tipo",
              value: planeta.familia,
            ),

            _buildInfoDetalle(
              icon: FontAwesomeIcons.chartLine,
              title: "Magnitud",
              value: planeta.magnitud.toStringAsFixed(2),
            ),

            const SizedBox(height: 15),

            Text(
              planeta.descripcion,
              style: const TextStyle(
                color: Color.fromARGB(255, 55, 66, 137),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoDetalle({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FaIcon(icon, color: const Color.fromARGB(255, 55, 66, 137), size: 16),
          const SizedBox(width: 12),
          Text(
            '$title: ',
            style: const TextStyle(
              color: Color.fromARGB(255, 55, 66, 137),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color.fromARGB(255, 77, 84, 209)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _recargarPlanetas,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 55, 66, 137),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
              label: const Text('Actualizar Datos'),
            ),
          ),
        ],
      ),
    );
  }
}
