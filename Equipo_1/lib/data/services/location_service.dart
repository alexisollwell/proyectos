import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_data.dart';
import 'ipinfo_service.dart';

class LocationService {
  static LocationData? _currentLocationData;

  static LocationData? get currentLocationData => _currentLocationData;
  static double? get latitud => _currentLocationData?.latitud;
  static double? get longitud => _currentLocationData?.longitud;
  static LatLng? get latLng =>
      _currentLocationData?.tieneCoordenadasValidas ?? false
      ? LatLng(_currentLocationData!.latitud!, _currentLocationData!.longitud!)
      : null;

  static bool get tieneDatosValidos =>
      _currentLocationData?.tieneCoordenadasValidas ?? false;

  static Future<LocationData> obtenerUbicacion() async {
    try {
      print('📍 Obteniendo ubicación desde IPInfo...');

      final ipInfoService = IpInfoService();
      final ipInfo = await ipInfoService.getIpInfo();

      _currentLocationData = LocationData.fromIpInfo(ipInfo);

      if (!_currentLocationData!.tieneCoordenadasValidas) {
        throw Exception(
          'No se pudieron obtener coordenadas válidas de la ubicación',
        );
      }

      print(
        '✅ Ubicación obtenida: ${_currentLocationData!.ciudad}, ${_currentLocationData!.pais}',
      );
      print(
        '✅ Coordenadas: ${_currentLocationData!.latitud}, ${_currentLocationData!.longitud}',
      );

      return _currentLocationData!;
    } catch (e) {
      print('❌ Error obteniendo ubicación: $e');
      _currentLocationData = null;
      rethrow;
    }
  }

  static Future<void> actualizarUbicacion() async {
    await obtenerUbicacion();
  }

  static void limpiarDatos() {
    _currentLocationData = null;
  }
}
