import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchProcessList() async {
  final prefs = await SharedPreferences.getInstance();
  final lid = prefs.getString('lid') ?? '';
  final imei = prefs.getString('imei') ?? 'D237DBC1-D0A6-4FB8-8E45-21C0785BB63E';
  final token = 'ABCD1';

  try {
    final url = Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/GetProcessListByLid_t');
    final response = await http.post(
      url,
      body: jsonEncode({
        "token": token,
        "imei": imei,
        "lid": lid,
        "openOrClose": "O",
        "daysFrom": 0,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched process list: $data");
      return data;
    } else {
      print("Failed response: ${response.body}");
      throw Exception('Failed to load process list');
    }
  } catch (e) {
    print("Error fetching process list: $e");
    throw Exception('Failed to load process list');
  }
}
