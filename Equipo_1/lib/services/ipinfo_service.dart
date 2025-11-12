import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ipinfo_model.dart';
import '../constants.dart';

class IpInfoService {
  static IpInfo? _ipInfoCache;

  static IpInfo? get ipInfoCache => _ipInfoCache;

  Future<IpInfo> getIpInfo() async {
    try {
      final response = await http.get(
        Uri.parse(ipInfoUrl),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _ipInfoCache = IpInfo.fromJson(jsonResponse);
        return _ipInfoCache!;
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

Future<IpInfo> getIpInfo() async {
  return await IpInfoService().getIpInfo();
}
