class Usuario {
  int? id;
  String email;
  String passwordHash;
  String nombre;
  String apellido;
  String genero;
  String? fotoPath;
  String fechaNacimiento;

  Usuario({
    this.id,
    required this.email,
    required this.passwordHash,
    required this.nombre,
    required this.apellido,
    required this.genero,
    this.fotoPath,
    required this.fechaNacimiento,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "passwordHash": passwordHash,
        "nombre": nombre,
        "apellido": apellido,
        "genero": genero,
        "fotoPath": fotoPath,
        "fechaNacimiento": fechaNacimiento,
      };

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
        id: map["id"],
        email: map["email"],
        passwordHash: map["passwordHash"],
        nombre: map["nombre"],
        apellido: map["apellido"],
        genero: map["genero"],
        fotoPath: map["fotoPath"],
        fechaNacimiento: map["fechaNacimiento"],
      );
}
