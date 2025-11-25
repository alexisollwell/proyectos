import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyectos/data/models/ip_info.dart';
import '../../core/constants/constants.dart';

class IpInfoService {
  static IpInfo? _ipInfoCache;

  static IpInfo? get ipInfoCache => _ipInfoCache;

  Future<IpInfo> getIpInfo() async {
    try {
      // ignore: avoid_print
      print('Obteniendo información de IP...');

      final response = await http.get(
        Uri.parse(ipInfoUrl),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _ipInfoCache = IpInfo.fromJson(jsonResponse);

        // ignore: avoid_print
        print('IPInfo obtenido: ${_ipInfoCache!.ip}');
        // ignore: avoid_print
        print('Ubicación: ${_ipInfoCache!.ciudad}, ${_ipInfoCache!.pais}');

        return _ipInfoCache!;
      } else {
        throw Exception('Error HTTP al obtener IPInfo: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error obteniendo IPInfo: $e');
      rethrow;
    }
  }
}

Future<IpInfo> getIpInfo() async {
  return await IpInfoService().getIpInfo();
}
