import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../model/documents_model.dart';

Future<File> fetchAndSaveDocument(int documentRSN) async {
  final response = await http.post(
    Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/GetDocumentContent_t'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'token': 'ABCD1', 'documentRSN': documentRSN}),
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    String base64String = jsonResponse['contentByte'];
    String contentType = jsonResponse['contentType'];

    // Decode base64 content
    List<int> fileBytes = base64.decode(base64String);

    // Get the appropriate directory to save the file
    Directory tempDir = await getTemporaryDirectory();

    // Map contentType to file extension
    String fileExtension;
    if (contentType == 'application/pdf') {
      fileExtension = 'pdf';
    } else if (contentType == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
      fileExtension = 'docx';
    } else {
      fileExtension = 'txt'; // Fallback if unknown content type
    }

    String filePath = '${tempDir.path}/document.$fileExtension';

    // Write the file to the file system
    File file = File(filePath);
    await file.writeAsBytes(fileBytes);

    return file;
  } else {
    throw Exception('Failed to load document content');
  }
}


Future<List<Document>> fetchDocuments() async {
  final response = await http.post(
    Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/GetFolderDocumentList_t'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'token': 'ABCD1',
      'folderRSN': 233853,
    }),
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((doc) => Document.fromJson(doc)).toList();
  } else {
    throw Exception('Failed to load documents');
  }
}