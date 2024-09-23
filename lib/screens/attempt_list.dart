import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../inactivitytimer.dart';
import '../service/attempt_list.dart';

class ProcessAttemptListPage extends StatefulWidget {
  final int processRSN;
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  const ProcessAttemptListPage({
    Key? key,
    required this.processRSN,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier,
  }) : super(key: key);

  @override
  _ProcessAttemptListPageState createState() => _ProcessAttemptListPageState();
}

class _ProcessAttemptListPageState extends State<ProcessAttemptListPage> {
  late Future<List<dynamic>> futureProcessAttemptList;

  @override
  void initState() {
    super.initState();
    futureProcessAttemptList = fetchProcessAttemptList(widget.processRSN);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [Scaffold(
        appBar: AppBar(
          title: const Text('Process Attempt List'),
          // actions: [
          //   TimerDisplay(
          //     inactivityTimerNotifier: widget.inactivityTimerNotifier,
          //     graceTimerNotifier: widget.graceTimerNotifier,
          //   ),
          // ],
        ),
        body: FutureBuilder<List<dynamic>>(
          future: futureProcessAttemptList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              List<dynamic>? processAttempts = snapshot.data;
              if (processAttempts != null && processAttempts.isNotEmpty) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Attempt Comment')),
                      DataColumn(label: Text('Attempt RSN')),
                      DataColumn(label: Text('Process RSN')),
                      DataColumn(label: Text('Result Code')),
                      DataColumn(label: Text('Result Description')),
                    ],
                    rows: processAttempts.map((attempt) {
                      return DataRow(cells: [
                        DataCell(Text(attempt['attemptComment'] ?? '')),
                        DataCell(Text(attempt['attemptRSN'].toString())),
                        DataCell(Text(attempt['processRSN'].toString())),
                        DataCell(Text(attempt['resultCode'].toString())),
                        DataCell(Text(attempt['resultDesc'] ?? '')),
                      ]);
                    }).toList(),
                  ),
                );
              } else {
                return const Center(child: Text("No attempts found"));
              }
            }
            return const Center(child: Text("No data available"));
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
    ]

    );
  }
}
