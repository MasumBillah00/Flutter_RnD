import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../app_model/process_model/attachment_model.dart';

Future<Uint8List?> fetchAttachmentContent(int attachmentRSN) async {
  final response = await http.post(
    Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/GetAttachmentContent_t'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({"token": "ABCD1", "attachmentRSN": attachmentRSN}),
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);

    // Print the full response to debug
    print("Full response: $jsonResponse");

    // Check for contentAsString instead of contentByte
    String? base64String = jsonResponse['contentAsString'];

    if (base64String != null) {
      Uint8List fileBytes = base64.decode(base64String);
      return fileBytes;
    } else {
      print('contentAsString is null');
      return null;
    }
  } else {
    throw Exception('Failed to load attachment content');
  }
}


Future<List<Attachment>> fetchAttachments() async {
  final response = await http.post(
    Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/GetFolderAttachmentList_t'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'token': 'ABCD1', 'folderRSN': 233853}),
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((attachment) => Attachment.fromJson(attachment)).toList();
  } else {
    throw Exception('Failed to load attachments');
  }
}