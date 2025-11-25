import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
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
      // ignore: avoid_print
      print('📍 Iniciando obtención de ubicación combinada...');

      final ipInfoData = await _obtenerDatosIPInfo();
      final gpsData = await _obtenerUbicacionGPS();

      _currentLocationData = LocationData(
        ip: ipInfoData.ip,
        ciudad: gpsData?.ciudad ?? ipInfoData.ciudad,
        estado: gpsData?.estado ?? ipInfoData.estado,
        pais: gpsData?.pais ?? ipInfoData.pais,
        loc: gpsData?.loc ?? ipInfoData.loc,
        latitud: gpsData?.latitud ?? ipInfoData.latitud,
        longitud: gpsData?.longitud ?? ipInfoData.longitud,
        timestamp: DateTime.now(),
        esGPS: gpsData != null,
        datosIP: ipInfoData,
      );

      // ignore: avoid_print
      print('✅ Datos combinados obtenidos:');
      // ignore: avoid_print
      print('   IP: ${_currentLocationData!.ip}');
      // ignore: avoid_print
      print('   Ciudad: ${_currentLocationData!.ciudad}');
      // ignore: avoid_print
      print(
        '   Coordenadas: ${_currentLocationData!.latitud}, ${_currentLocationData!.longitud}',
      );
      // ignore: avoid_print
      print('   Tipo: ${_currentLocationData!.esGPS ? "GPS" : "IP"}');

      return _currentLocationData!;
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error obteniendo ubicación combinada: $e');

      _currentLocationData = LocationData(
        ip: 'No disponible',
        ciudad: 'Ubicación no disponible',
        estado: 'Error',
        pais: 'México',
        loc: '0,0',
        latitud: 19.4326,
        longitud: -99.1332,
        timestamp: DateTime.now(),
        esGPS: false,
        datosIP: null,
      );

      return _currentLocationData!;
    }
  }

  static Future<LocationData> _obtenerDatosIPInfo() async {
    try {
      // ignore: avoid_print
      print('📍 Obteniendo datos de IPInfo...');
      final ipInfoService = IpInfoService();
      final ipInfo = await ipInfoService.getIpInfo();

      return LocationData.fromIpInfo(ipInfo);
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error en IPInfo: $e');
      return LocationData(
        ip: 'No disponible',
        ciudad: 'No detectada',
        estado: 'No detectado',
        pais: 'No detectado',
        loc: '',
        latitud: null,
        longitud: null,
        timestamp: DateTime.now(),
        esGPS: false,
      );
    }
  }

  static Future<LocationData?> _obtenerUbicacionGPS() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // ignore: avoid_print
        print('❌ Servicios de ubicación desactivados');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // ignore: avoid_print
          print('❌ Permisos de ubicación denegados');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // ignore: avoid_print
        print('❌ Permisos de ubicación denegados permanentemente');
        return null;
      }

      // ignore: avoid_print
      print('📍 Obteniendo posición GPS...');
      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.best,
        // ignore: deprecated_member_use
        timeLimit: const Duration(seconds: 10),
      );

      // ignore: avoid_print
      print('✅ GPS obtenido: ${position.latitude}, ${position.longitude}');

      return LocationData(
        ip: 'GPS',
        ciudad: 'Tu ubicación actual',
        estado: 'GPS',
        pais: 'GPS',
        loc: '${position.latitude},${position.longitude}',
        latitud: position.latitude,
        longitud: position.longitude,
        timestamp: DateTime.now(),
        esGPS: true,
      );
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error en GPS: $e');
      return null;
    }
  }

  static Future<void> actualizarUbicacion() async {
    await obtenerUbicacion();
  }

  static void limpiarDatos() {
    _currentLocationData = null;
  }
}
