import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<http.Response> enableBiometric(String token, String imei, String lid, String deviceId) async {
    return await http.post(
      Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/EnableBiometric'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": token,
        "imei": imei,
        "lid": lid,
        "deviceID": deviceId,
      }),
    );
  }

  static Future<http.Response> autoLoginBiometric(String token, String imei, String userId, String deviceId, String bioToken) async {
    return await http.post(
      Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/AutoLoginByBiometric'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": token,
        "imei": imei,
        "userID": userId,
        "deviceID": deviceId,
        "bioToken": bioToken,
      }),
    );
  }
}
