import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../constants.dart';

Future<List<User>> getUsers() async {
  try {
    final res = await http.get(Uri.parse("$usersUrl?page=1"));
    if (res.statusCode == 200) {
      var data = json.decode(res.body)['data'] as List;
      return data.map((u) => User.fromJson(u)).toList();
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}
