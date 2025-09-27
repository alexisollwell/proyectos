import 'dart:ffi';

class AlumnoRequest {
  int? id, matricula;
  List<String> listadoDeMatriculas;
  bool estaActivo;

  AlumnoRequest({
    this.id,
    this.matricula,
    this.listadoDeMatriculas = const [],
    this.estaActivo = false,
  });
}
