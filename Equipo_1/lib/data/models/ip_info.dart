class IpInfo {
  String ip;
  String ciudad;
  String estado;
  String pais;
  String loc;

  double? _latitud;
  double? _longitud;

  IpInfo({
    this.ip = "",
    this.ciudad = "",
    this.estado = "",
    this.pais = "",
    this.loc = "",
  }) {
    _procesarUbicacion();
  }

  factory IpInfo.fromJson(Map<String, dynamic> json) {
    return IpInfo(
      ip: json['ip'] ?? "",
      ciudad: json['city'] ?? "",
      estado: json['region'] ?? "",
      pais: json['country'] ?? "",
      loc: json['loc'] ?? "",
    );
  }

  void _procesarUbicacion() {
    if (loc.isNotEmpty && loc.contains(',')) {
      try {
        List<String> coordenadas = loc.split(',');
        if (coordenadas.length == 2) {
          _latitud = double.tryParse(coordenadas[0]);
          _longitud = double.tryParse(coordenadas[1]);
        }
      } catch (e) {
        print('Error al procesar coordenadas: $e');
      }
    }
  }

  double? get latitud => _latitud;
  double? get longitud => _longitud;

  bool get tieneCoordenadasValidas => _latitud != null && _longitud != null;

  String get coordenadasFormateadas =>
      tieneCoordenadasValidas ? '$_latitud, $_longitud' : 'No disponible';

  @override
  String toString() {
    return 'IP: $ip\nCiudad: $ciudad\nRegión: $estado\nPaís: $pais\nUbicación: $loc\nLatitud: ${latitud ?? "N/A"}\nLongitud: ${longitud ?? "N/A"}';
  }
}
