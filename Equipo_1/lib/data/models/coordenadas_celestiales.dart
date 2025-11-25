class CoordenadasCelestiales {
  final double altitude;
  final double azimuth;
  final double? fixedAltitude;
  final double? fixedAzimuth;
  const CoordenadasCelestiales({
    required this.altitude,
    required this.azimuth,
    this.fixedAltitude,
    this.fixedAzimuth,
  });

  CoordenadasCelestiales copyWith({
    double? altitude,
    double? azimuth,
    double? fixedAltitude,
    double? fixedAzimuth,
  }) {
    return CoordenadasCelestiales(
      altitude: altitude ?? this.altitude,
      azimuth: azimuth ?? this.azimuth,
      fixedAltitude: fixedAltitude ?? this.fixedAltitude,
      fixedAzimuth: fixedAzimuth ?? this.fixedAzimuth,
    );
  }

  double get currentAltitude => fixedAltitude ?? altitude;
  double get currentAzimuth => fixedAzimuth ?? azimuth;
}
