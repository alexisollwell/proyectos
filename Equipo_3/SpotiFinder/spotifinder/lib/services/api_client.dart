import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/config.dart';

class ApiClient {
  Future<String> getAccessToken() async {
    final response = await http.get(Uri.parse("${Config.backendBaseUrl}/token"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["access_token"];
    } else {
      throw Exception("Error obteniendo token: ${response.body}");
    }
  }
}
