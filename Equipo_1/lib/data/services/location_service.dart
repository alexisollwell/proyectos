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
      print('📍 Iniciando obtención de ubicación combinada...');

      // Obtener datos de IPInfo y GPS simultáneamente
      final ipInfoData = await _obtenerDatosIPInfo();
      final gpsData = await _obtenerUbicacionGPS();

      // Combinar datos: IP de IPInfo, ubicación de GPS (si está disponible)
      _currentLocationData = LocationData(
        ip: ipInfoData.ip,
        ciudad: gpsData?.ciudad ?? ipInfoData.ciudad,
        estado: gpsData?.estado ?? ipInfoData.estado,
        pais: gpsData?.pais ?? ipInfoData.pais,
        loc: gpsData?.loc ?? ipInfoData.loc,
        latitud: gpsData?.latitud ?? ipInfoData.latitud,
        longitud: gpsData?.longitud ?? ipInfoData.longitud,
        timestamp: DateTime.now(),
        esGPS: gpsData != null, // True si tenemos datos de GPS
        datosIP: ipInfoData, // Mantenemos los datos de IPInfo
      );

      print('✅ Datos combinados obtenidos:');
      print('   IP: ${_currentLocationData!.ip}');
      print('   Ciudad: ${_currentLocationData!.ciudad}');
      print(
        '   Coordenadas: ${_currentLocationData!.latitud}, ${_currentLocationData!.longitud}',
      );
      print('   Tipo: ${_currentLocationData!.esGPS ? "GPS" : "IP"}');

      return _currentLocationData!;
    } catch (e) {
      print('❌ Error obteniendo ubicación combinada: $e');

      // Fallback con datos básicos
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
      print('📍 Obteniendo datos de IPInfo...');
      final ipInfoService = IpInfoService();
      final ipInfo = await ipInfoService.getIpInfo();

      return LocationData.fromIpInfo(ipInfo);
    } catch (e) {
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
      // Verificar permisos
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ Servicios de ubicación desactivados');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('❌ Permisos de ubicación denegados');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('❌ Permisos de ubicación denegados permanentemente');
        return null;
      }

      // Obtener ubicación actual
      print('📍 Obteniendo posición GPS...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );

      print('✅ GPS obtenido: ${position.latitude}, ${position.longitude}');

      return LocationData(
        ip: 'GPS', // Esto será sobrescrito por IPInfo
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
