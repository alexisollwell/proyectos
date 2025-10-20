import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ipinfo_model.dart';
import '../constants.dart';

Future<IpInfo> getIpInfo() async {
  try {
    final res = await http.get(Uri.parse(ipInfoUrl));
    if (res.statusCode == 200) {
      var jsonResponse = json.decode(res.body);
      return IpInfo.fromJson(jsonResponse);
    } else {
      return IpInfo(ip: "Error al obtener datos");
    }
  } catch (e) {
    return IpInfo(ip: e.toString());
  }
}
