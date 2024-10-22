import 'package:flutter/material.dart';

import '../../../inactivitytimer.dart';
import '../../../service/attempt_list.dart';

class AttemptResultListPage extends StatefulWidget {
  final int processRSN;
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  const AttemptResultListPage({
    Key? key,
    required this.processRSN,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier,
  }) : super(key: key);

  @override
  _AttemptResultListPageState createState() => _AttemptResultListPageState();
}

class _AttemptResultListPageState extends State<AttemptResultListPage> {
  late Future<List<DropdownMenuItem<String>>> futureDropdownItems;
  String? selectedResult;

  @override
  void initState() {
    super.initState();
    futureDropdownItems = fetchAttemptResults(widget.processRSN);
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ Scaffold(
        appBar: AppBar(
          title: const Text('Attempt Results'),
        ),
        body: Center(
          child: FutureBuilder<List<DropdownMenuItem<String>>>(
            future: futureDropdownItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: selectedResult,
                      items: snapshot.data!,
                      onChanged: (newValue) {
                        setState(() {
                          selectedResult = newValue!;
                        });
                      },
                      hint: const Text("Select an Attempt Result"),
                    ),
                    const SizedBox(height: 20),
                    if (selectedResult != null) Text('Selected Result Value: $selectedResult'),
                  ],
                );
              }
              return const Text("No results found");
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
    ]
    );
  }
}

