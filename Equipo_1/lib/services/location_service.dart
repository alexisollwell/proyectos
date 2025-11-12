import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/ipinfo_model.dart';
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
      final ipInfo = await IpInfoService().getIpInfo();

      _currentLocationData = LocationData.fromIpInfo(ipInfo);

      return _currentLocationData!;
    } catch (e) {
      throw Exception('Error al obtener ubicación: $e');
    }
  }

  static Future<void> actualizarUbicacion() async {
    await obtenerUbicacion();
  }

  static void limpiarDatos() {
    _currentLocationData = null;
  }
}
