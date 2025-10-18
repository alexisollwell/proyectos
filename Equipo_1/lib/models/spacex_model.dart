class Constelacion {
  String nombre;
  String visibilidad;
  String mejorhorario;
  String descripcion;

  Constelacion({
    this.nombre = "",
    this.visibilidad = "",
    this.mejorhorario = "",
    this.descripcion = "",
  });

  factory Constelacion.fromJson(Map<String, dynamic> json) {
    return Constelacion(
      nombre: json['name'] ?? "No name",
      visibilidad: json['visibility'] ?? "Unknown",
      mejorhorario: json['best_time'] ?? "Unknown",
      descripcion: json['description'] ?? "No description available",
    );
  }
}
