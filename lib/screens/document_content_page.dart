import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../inactivitytimer.dart';
import '../service/document_list.dart';

class DocumentContentPage extends StatefulWidget {
  final int documentRSN;
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  const DocumentContentPage({Key? key, required this.documentRSN, required this.inactivityTimerNotifier, required this.graceTimerNotifier}) : super(key: key);

  @override
  _DocumentContentPageState createState() => _DocumentContentPageState();
}

class _DocumentContentPageState extends State<DocumentContentPage> {
  late Future<File> futureDocumentFile;

  @override
  void initState() {
    super.initState();
    futureDocumentFile = fetchAndSaveDocument(widget.documentRSN);
  }



  void openDocument(File file) async {
    final result = await OpenFile.open(file.path);
    print('File saved at: ${file.path}');
    print("Open result: ${result.type}, Message: ${result.message}");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: const Text('Document Content'),
          // actions: [
          //   TimerDisplay(
          //     inactivityTimerNotifier: widget.inactivityTimerNotifier,
          //     graceTimerNotifier: widget.graceTimerNotifier,
          //   ),
          // ],
        ),
        body: Center(
          child: FutureBuilder<File>(
            future: futureDocumentFile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Document fetched successfully!"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => openDocument(snapshot.data!),
                      child: const Text('Open Document'),
                    ),
                  ],
                );
              }
              return const Text("No data found");
            },
          ),
        ),
      ),
      Positioned(
        bottom: 70,
        right: 10,
        child: TimerDisplay(
          inactivityTimerNotifier: widget.inactivityTimerNotifier,
          graceTimerNotifier: widget.graceTimerNotifier,
        ),
      ),
    ]);
  }
}
