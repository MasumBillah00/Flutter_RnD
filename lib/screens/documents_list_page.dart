import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../inactivitytimer.dart';
import '../model/documents_model.dart';
import '../service/document_list.dart';

class DocumentListPage extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;
  const DocumentListPage({
    super.key,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier,
  });

  @override
  _DocumentListPageState createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  late Future<List<Document>> futureDocuments;

  @override
  void initState() {
    super.initState();
    futureDocuments = fetchDocuments();
  }



  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: const Text('Document List'),
          // actions: [
          //   TimerDisplay(
          //     inactivityTimerNotifier: widget.inactivityTimerNotifier,
          //     graceTimerNotifier: widget.graceTimerNotifier,
          //   ),
          // ],
        ),
        body: FutureBuilder<List<Document>>(
          future: futureDocuments,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Document> documents = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('RSN')),
                    ],
                    rows: documents.map((doc) {
                      return DataRow(cells: [
                        DataCell(Text(doc.documentDesc)),
                        DataCell(Text(doc.documentRSN.toString())),
                      ]);
                    }).toList(),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
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
