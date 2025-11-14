import 'dart:convert';

String usersUrl = "https://reqres.in/api/users";

const String astronomyAppId = '4cd00d9c-cfe1-438b-a685-56b860b1fbed';
const String astronomyAppSecret =
    '74a66015888f7dd4d8450fd837ca8affa8676296ca225de002112d2f74685097b2ec899c3fddabd77bde3db4aeac717174f0497d29d144da77782242d757541cb99878c8e3ac545f368321ea3068ead43c661cc315227171409c8116f98cc7cbb93cfeae91b73eff6f9e5718c554463e';

String planetasUrl() {
  return 'https://api.astronomyapi.com/api/v2/bodies/positions';
}

const Map<String, Map<String, String>> planetasInfo = {
  'sun': {'es': 'Sol', 'en': 'Sun', 'id': 'sun'},
  'moon': {'es': 'Luna', 'en': 'Moon', 'id': 'moon'},
  '199': {'es': 'Mercurio', 'en': 'Mercury', 'id': '199'},
  '299': {'es': 'Venus', 'en': 'Venus', 'id': '299'},
  '399': {'es': 'Tierra', 'en': 'Earth', 'id': '399'},
  '499': {'es': 'Marte', 'en': 'Mars', 'id': '499'},
  '599': {'es': 'Júpiter', 'en': 'Jupiter', 'id': '599'},
  '699': {'es': 'Saturno', 'en': 'Saturn', 'id': '699'},
  '799': {'es': 'Urano', 'en': 'Uranus', 'id': '799'},
  '899': {'es': 'Neptuno', 'en': 'Neptune', 'id': '899'},
};

String getAstronomyAuthString() {
  final credentials = '$astronomyAppId:$astronomyAppSecret';
  final bytes = utf8.encode(credentials);
  final base64Str = base64.encode(bytes);
  return 'Basic $base64Str';
}

String getCurrentDate() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

String getCurrentTime() {
  final now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
}

String ipInfoUrl = "https://ipinfo.io/json";

