import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/track.dart';

class SpotifyService {
  final String baseUrl = "http://172.18.9.107:3000"; 
  // 👆 Cambia a tu IP local si corres en dispositivo físico o Flutter Web

  Future<List<Track>> searchSpotify(String query) async {
    final response = await http.get(
      Uri.parse("$baseUrl/search?q=$query&type=track"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data["tracks"]["items"] as List;
      return items.map((item) => Track.fromJson(item)).toList();
    } else {
      throw Exception("Error en búsqueda: ${response.statusCode}");
    }
  }
}
