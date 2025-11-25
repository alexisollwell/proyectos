import 'package:proyectos/data/models/ip_info.dart';

class LocationData {
  final String ip;
  final String ciudad;
  final String estado;
  final String pais;
  final String loc;
  final double? latitud;
  final double? longitud;
  final DateTime? timestamp;
  final bool esGPS;
  final LocationData? datosIP;

  LocationData({
    required this.ip,
    required this.ciudad,
    required this.estado,
    required this.pais,
    required this.loc,
    this.latitud,
    this.longitud,
    this.timestamp,
    this.esGPS = false,
    this.datosIP,
  });

  factory LocationData.fromIpInfo(IpInfo ipInfo) {
    double? lat;
    double? lng;

    if (ipInfo.loc.isNotEmpty && ipInfo.loc.contains(',')) {
      try {
        List<String> coordenadas = ipInfo.loc.split(',');
        if (coordenadas.length == 2) {
          lat = double.tryParse(coordenadas[0]);
          lng = double.tryParse(coordenadas[1]);
        }
      } catch (e) {
        // ignore: avoid_print
        print('Error al procesar coordenadas IPInfo: $e');
      }
    }

    return LocationData(
      ip: ipInfo.ip,
      ciudad: ipInfo.ciudad,
      estado: ipInfo.estado,
      pais: ipInfo.pais,
      loc: ipInfo.loc,
      latitud: lat,
      longitud: lng,
      timestamp: DateTime.now(),
      esGPS: false,
    );
  }

  bool get tieneCoordenadasValidas => latitud != null && longitud != null;

  String get coordenadasFormateadas => tieneCoordenadasValidas
      ? '${latitud!.toStringAsFixed(6)}, ${longitud!.toStringAsFixed(6)}'
      : 'No disponible';

  String get tipoUbicacion => esGPS ? 'GPS Precisa' : 'Aproximada por IP';

  String get ciudadIP => datosIP?.ciudad ?? 'No disponible';

  String get paisIP => datosIP?.pais ?? 'No disponible';

  @override
  String toString() {
    return 'IP: $ip\nCiudad: $ciudad\nRegión: $estado\nPaís: $pais\nCoordenadas: $coordenadasFormateadas\nTipo: $tipoUbicacion';
  }
}
