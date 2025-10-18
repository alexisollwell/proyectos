import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:equipo1_practica5/constants.dart';
import 'package:equipo1_practica5/models/spacex_model.dart';

Future<Constelacion> getConstelacion(double lat, double lng) async {
  try {
    final res = await http.get(Uri.parse(constelacionUrl(lat, lng)));

    if (res.statusCode == 200) {
      var jsonResponse = json.decode(res.body);

      return Constelacion(
        nombre: jsonResponse['data']['constellations'][0]['name'] ?? "Unknown",
        visibilidad: jsonResponse['data']['constellations'][0]['visible']
            ? "Visible"
            : "Not Visible",
        mejorhorario: "Tonight",
        descripcion: "Constellation visible from your location",
      );
    } else {
      return Constelacion(
        nombre: "Error: ${res.statusCode}",
        descripcion: "No se pudieron obtener datos de constelaciones",
      );
    }
  } catch (e) {
    return Constelacion(
      nombre: "Orion",
      visibilidad: "Visible",
      mejorhorario: "20:00 - 22:00",
      descripcion:
          "Una de las constelaciones más reconocibles, visible en el cielo nocturno.",
    );
  }
}
