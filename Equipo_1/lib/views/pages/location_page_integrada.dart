import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proyectos/models/location_data.dart';
import 'package:proyectos/services/location_service.dart';

class IntegratedLocationPage extends StatefulWidget {
  const IntegratedLocationPage({super.key});

  @override
  State<IntegratedLocationPage> createState() => _IntegratedLocationPageState();
}

class _IntegratedLocationPageState extends State<IntegratedLocationPage> {
  GoogleMapController? _mapController;
  LocationData? _locationData;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadLocationData();
  }

  Future<void> _loadLocationData() async {
    try {
      setState(() {
        _loading = true;
        _error = false;
      });

      final locationData = await LocationService.obtenerUbicacion();

      setState(() {
        _locationData = locationData;
        _loading = false;
      });

      if (_locationData?.tieneCoordenadasValidas ?? false) {
        _centerMapOnLocation();
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void _centerMapOnLocation() {
    if (_mapController != null && _locationData!.tieneCoordenadasValidas ??
        false) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_locationData!.latitud!, _locationData!.longitud!),
          12,
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    Future.delayed(const Duration(milliseconds: 500), () {
      _centerMapOnLocation();
    });
  }

  Set<Marker> _getMarkers() {
    if (_locationData?.tieneCoordenadasValidas ?? false) {
      return {
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(_locationData!.latitud!, _locationData!.longitud!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: _locationData!.ciudad.isNotEmpty
                ? _locationData!.ciudad
                : 'Tu Ubicación',
            snippet: _locationData!.pais.isNotEmpty
                ? '${_locationData!.estado}, ${_locationData!.pais}'
                : 'Basado en tu IP',
          ),
        ),
      };
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 243, 251),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(flex: 2, child: _buildMapSection()),
            _buildInfoSection(),
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
            "MAPA & GEOLOCALIZACIÓN",
            style: GoogleFonts.bebasNeue(
              fontSize: 20,
              color: const Color.fromARGB(255, 69, 55, 137),
            ),
          ),
          Container(
            width: 44,
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: _loading
              ? _buildMapLoading()
              : _locationData?.tieneCoordenadasValidas ?? false
              ? _buildInteractiveMap()
              : _buildMapError(),
        ),
      ),
    );
  }

  Widget _buildInteractiveMap() {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(_locationData!.latitud!, _locationData!.longitud!),
            zoom: 10,
          ),
          markers: _getMarkers(),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
        ),
        Positioned(
          top: 10,
          right: 10,
          child: FloatingActionButton.small(
            onPressed: _centerMapOnLocation,
            backgroundColor: const Color.fromARGB(255, 55, 66, 137),
            foregroundColor: Colors.white,
            child: const Icon(Icons.my_location, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildMapLoading() {
    return Container(
      color: const Color.fromARGB(255, 212, 220, 240),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color.fromARGB(255, 55, 66, 137)),
            SizedBox(height: 16),
            Text(
              'Cargando mapa...',
              style: TextStyle(color: Color.fromARGB(255, 55, 66, 137)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapError() {
    return Container(
      color: const Color.fromARGB(255, 212, 220, 240),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.mapLocationDot,
              color: Color.fromARGB(255, 55, 66, 137),
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'No se pudieron cargar las coordenadas',
              style: TextStyle(
                color: Color.fromARGB(255, 55, 66, 137),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadLocationData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 55, 66, 137),
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 161, 167, 254),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: _loading
          ? _buildInfoLoading()
          : _error
          ? _buildInfoError()
          : _buildInfoContent(),
    );
  }

  Widget _buildInfoLoading() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 55, 66, 137),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const FaIcon(
            FontAwesomeIcons.solidCircle,
            color: Color.fromARGB(255, 212, 212, 240),
            size: 20,
          ),
        ),
        const SizedBox(width: 15),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Obteniendo información...',
                style: TextStyle(
                  color: Color.fromARGB(255, 55, 66, 137),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              LinearProgressIndicator(
                color: Color.fromARGB(255, 55, 66, 137),
                backgroundColor: Color.fromARGB(255, 212, 212, 240),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoError() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 55, 66, 137),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const FaIcon(
            FontAwesomeIcons.triangleExclamation,
            color: Color.fromARGB(255, 212, 212, 240),
            size: 20,
          ),
        ),
        const SizedBox(width: 15),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Error al obtener datos',
                style: TextStyle(
                  color: Color.fromARGB(255, 55, 66, 137),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Verifica tu conexión a internet',
                style: TextStyle(
                  color: Color.fromARGB(255, 77, 84, 209),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoContent() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 55, 66, 137),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const FaIcon(
                FontAwesomeIcons.locationDot,
                color: Color.fromARGB(255, 212, 212, 240),
                size: 20,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _locationData!.ciudad.isNotEmpty
                        ? _locationData!.ciudad
                        : 'Ubicación Detectada',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 55, 66, 137),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _locationData!.pais.isNotEmpty
                        ? '${_locationData!.estado}, ${_locationData!.pais}'
                        : 'Basado en tu dirección IP',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 77, 84, 209),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoGrid(),
      ],
    );
  }

  Widget _buildInfoGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _buildInfoItem('IP', _locationData!.ip),
        _buildInfoItem('Coordenadas', _locationData!.coordenadasFormateadas),
        _buildInfoItem('Región', _locationData!.estado),
        _buildInfoItem('País', _locationData!.pais),
      ],
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 212, 212, 240),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(255, 55, 66, 137),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color.fromARGB(255, 77, 84, 209),
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
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
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                if (_locationData?.tieneCoordenadasValidas ?? false) {
                  // Navigator.push(...);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 161, 167, 254),
                foregroundColor: const Color.fromARGB(255, 55, 66, 137),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const FaIcon(FontAwesomeIcons.star, size: 16),
              label: const Text('Constelaciones'),
            ),
          ),
        ],
      ),
    );
  }
}
