import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../inactivitytimer.dart';
import '../../../service/attachment_list.dart';


class AttachmentContentPage extends StatefulWidget {
  final int attachmentRSN;
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;
  AttachmentContentPage({
    Key? key,
    required this.attachmentRSN,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier,
  }) : super(key: key);

  @override
  _AttachmentContentPageState createState() => _AttachmentContentPageState();
}

class _AttachmentContentPageState extends State<AttachmentContentPage> {
  late Future<Uint8List?> futureAttachmentContent;

  @override
  void initState() {
    super.initState();
    futureAttachmentContent = fetchAttachmentContent(widget.attachmentRSN);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ Scaffold(
        appBar: AppBar(
          title: const Text('Attachment Content'),
        ),
        body: Center(
          child: FutureBuilder<Uint8List?>(
            future: futureAttachmentContent,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return Image.memory(snapshot.data!);
                } else {
                  return const Text('No content available');
                }
              }
              return const Text("No content found");
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
