class Constelacion {
  final String nombre;
  final String visibilidad;
  final String mejorhorario;
  final String descripcion;
  final String? imagenUrl;
  final double magnitud;
  final String familia;
  final String? id;
  final String tipo;
  Constelacion({
    required this.nombre,
    required this.visibilidad,
    required this.mejorhorario,
    required this.descripcion,
    this.imagenUrl,
    required this.magnitud,
    required this.familia,
    this.id,
    this.tipo = 'planeta',
  });
  String get nombreSoloEspanol {
    final index = nombre.indexOf(' (');
    return index > 0 ? nombre.substring(0, index) : nombre;
  }

  String get nombreSoloIngles {
    final startIndex = nombre.indexOf('(');
    final endIndex = nombre.indexOf(')');
    if (startIndex > 0 && endIndex > startIndex) {
      return nombre.substring(startIndex + 1, endIndex);
    }
    return nombre;
  }

  factory Constelacion.fromAstronomyAPI(Map<String, dynamic> data) {
    return Constelacion(
      id: data['id']?.toString(),
      nombre: data['name']?.toString() ?? 'Planeta',
      visibilidad: data['visible']?.toString() ?? 'Visible',
      mejorhorario: data['best_time']?.toString() ?? '20:00 - 23:00',
      descripcion:
          data['description']?.toString() ??
          'Planeta visible desde tu ubicación',
      magnitud: _parsearMagnitud(data['magnitude']),
      familia: data['family']?.toString() ?? 'Planeta',
      imagenUrl: data['image_url'],
      tipo: data['type']?.toString() ?? 'planeta',
    );
  }
  static double _parsearMagnitud(dynamic magnitude) {
    if (magnitude == null) return 0.0;
    if (magnitude is double) return magnitude;
    if (magnitude is int) return magnitude.toDouble();
    if (magnitude is String) return double.tryParse(magnitude) ?? 0.0;
    return 0.0;
  }
}
