
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<List<dynamic>> fetchProcessAttemptList(int processRSN) async {
  final response = await http.post(
    Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/GetProcessAttemptList_t'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({"token": "ABCD1", "processRSN": processRSN}),
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  } else {
    throw Exception('Failed to load process attempts');
  }
}

// Future<List<String>> fetchAttemptResults(int processRSN) async {
//   final response = await http.post(
//     Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/GetAttemptResultList_t'),
//     headers: {
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({"token": "ABCD1", "processRSN": processRSN}),
//   );
//
//   if (response.statusCode == 200) {
//     List<dynamic> jsonResponse = jsonDecode(response.body);
//     // Map the result to a list of Strings (e.g., the 'text' field of the response)
//     List<String> items = jsonResponse.map<String>((result) => result['text'] as String).toList();
//
//     return items;
//   } else {
//     throw Exception('Failed to load attempt results');
//   }
// }


Future<List<DropdownMenuItem<String>>> fetchAttemptResults(int processRSN) async {
  final response = await http.post(
    Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/GetAttemptResultList_t'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({"token": "ABCD1", "processRSN": processRSN}),
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    List<DropdownMenuItem<String>> items = jsonResponse.map((result) {
      return DropdownMenuItem<String>(
        value: result['value'],
        child: Text(result['text']),
      );
    }).toList();

    return items;
  } else {
    throw Exception('Failed to load attempt results');
  }
}

