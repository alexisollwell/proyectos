class User {
  int id;
  String correo;
  String primerNombre;
  String apellido;
  String avatar;

  User({
    this.id = 0,
    this.correo = "",
    this.primerNombre = "",
    this.apellido = "",
    this.avatar = "",
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      correo: json['email'] ?? "",
      primerNombre: json['first_name'] ?? "",
      apellido: json['last_name'] ?? "",
      avatar: json['avatar'] ?? "",
    );
  }
}
