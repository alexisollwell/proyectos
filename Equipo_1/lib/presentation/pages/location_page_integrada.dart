import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:proyectos/data/models/location_data.dart';
import 'package:proyectos/data/services/location_service.dart';
import 'package:proyectos/presentation/pages/spacex_page.dart';
import 'package:flutter_compass/flutter_compass.dart';

class IntegratedLocationPage extends StatefulWidget {
  const IntegratedLocationPage({super.key});

  @override
  State<IntegratedLocationPage> createState() => _IntegratedLocationPageState();
}

class _IntegratedLocationPageState extends State<IntegratedLocationPage> {
  MapController? _mapController;
  LocationData? _locationData;
  bool _loading = true;
  bool _error = false;
  // ignore: unused_field
  double _heading = 0.0;
  // ignore: unused_field
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _loadLocationData();
    FlutterCompass.events!.listen((event) {
      setState(() {
        _heading = event.heading ?? 0;
      });
    });
  }

  Future<void> _loadLocationData() async {
    try {
      setState(() {
        _loading = true;
        _error = false;
        _errorMessage = '';
      });

      final locationData = await LocationService.obtenerUbicacion();

      setState(() {
        _locationData = locationData;
        _loading = false;
        _error = !(_locationData?.tieneCoordenadasValidas ?? false);
      });

      if (_locationData != null) {
        _centerMapOnLocation();
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
        _errorMessage = e.toString();
      });
    }
  }

void _centerMapOnLocation() {
  if (_mapController != null && _locationData != null) {
    final lat = _locationData!.latitud!;
    final lng = _locationData!.longitud!;

    _mapController!.move(
      LatLng(lat, lng),
      15,
    );
  }
}

  List<Marker> _getMarkers() {
    if (_locationData != null) {
      final lat = _locationData!.latitud ?? 19.4326;
      final lng = _locationData!.longitud ?? -99.1332;

      return [
        Marker(
  point: LatLng(lat, lng),
  width: 60,
  height: 60,
  child: Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 161, 167, 254),
              Color.fromARGB(255, 55, 66, 137),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
            ),
          ],
        ),
      ),
      const Icon(
        Icons.navigation,
        color: Colors.white,
        size: 20,
      ),
    ],
  ),
),


      ];
    }
    return [];
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
            "MAPA & GEOLOCALIZACIÓN",
            style: GoogleFonts.bebasNeue(
              fontSize: 20,
              color: const Color.fromARGB(255, 69, 55, 137),
            ),
          ),
          Container(width: 44),
        ],
      ),
    );
  }

Widget _buildMapSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Container(
      decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(24),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Color(0xFF4E3CFF).withOpacity(0.25),
      blurRadius: 18,
      offset: Offset(0, 10),
    ),
  ],
),

      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _loading ? _buildMapLoading() : _buildInteractiveMap(),
      ),
    ),
  );
}


  Widget _buildInteractiveMap() {
    final lat = _locationData?.latitud ?? 19.4326;
    final lng = _locationData?.longitud ?? -99.1332;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
                    initialCenter: LatLng(lat, lng),
                    initialZoom: 15,
                    maxZoom: 18,
                    minZoom: 5,
                  ),

          children: [
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/vianneycoffey/cmj3yzxsp00br01sl3ppr0x6b/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoidmlhbm5leWNvZmZleSIsImEiOiJjbWozeGc4aXEwbXJlM2ZxMnIxb25mZWFzIn0.3xuR9w1Dvqaa6BVf7wTPjQ',
              additionalOptions: {
                'accessToken': 'TU_MAPBOX_TOKEN',
                'id': 'mapbox.mapbox-streets-v8',
              },
            ),

            

            MarkerLayer(markers: _getMarkers()),
          ],
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
        if (!_locationData!.esGPS && _error)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.orange.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, size: 16, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'Ubicación aproximada',
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

  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 161, 167, 254),
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
      child: _loading ? _buildInfoLoading() : _buildInfoContent(),
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
          child: FaIcon(
            FontAwesomeIcons.locationDot,
              color: Colors.greenAccent,
              size: 36, 
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

  Widget _buildInfoContent() {
    return Column(
      children: [
        _buildIPInfo(),
        const SizedBox(height: 16),
        _buildLocationInfo(),
        const SizedBox(height: 12),
        _buildInfoGrid(),
      ],
    );
  }

  Widget _buildIPInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 212, 212, 240),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 77, 84, 209),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const FaIcon(
              FontAwesomeIcons.networkWired,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Información de Red',
                  style: TextStyle(
                    color: Color.fromARGB(255, 55, 66, 137),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'IP: ${_locationData!.ip}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 77, 84, 209),
                    fontSize: 12,
                  ),
                ),
                if (_locationData!.datosIP != null &&
                    !_locationData!.esGPS) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Ubicación por IP: ${_locationData!.datosIP!.ciudad}, ${_locationData!.datosIP!.pais}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 100, 100, 150),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _locationData!.esGPS
                ? Colors.green
                : const Color.fromARGB(255, 55, 66, 137),
            borderRadius: BorderRadius.circular(12),
          ),
          child: FaIcon(
            _locationData!.esGPS
                ? FontAwesomeIcons.satellite
                : FontAwesomeIcons.locationDot,
            color: Colors.white,
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
              const SizedBox(height: 4),
              Text(
                _locationData!.esGPS
                    ? '📍 Ubicación precisa por GPS'
                    : '📍 Ubicación aproximada por IP',
                style: TextStyle(
                  color: _locationData!.esGPS ? Colors.green : Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
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
        _buildInfoItem('Tipo', _locationData!.esGPS ? 'GPS' : 'IP'),
        _buildInfoItem(
          'Precisión',
          _locationData!.esGPS ? 'Alta' : 'Media',
          valueColor: _locationData!.esGPS ? Colors.green : Colors.orange,
        ),
      ],
    );
  }

  Widget _buildInfoItem(String title, String value, {Color? valueColor}) {
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
            style: TextStyle(
              color: valueColor ?? const Color.fromARGB(255, 77, 84, 209),
              fontSize: 11,
              fontWeight: valueColor != null
                  ? FontWeight.bold
                  : FontWeight.normal,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaginaConstelacion(),
                  ),
                );
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
