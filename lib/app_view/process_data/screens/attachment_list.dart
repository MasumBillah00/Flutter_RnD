import 'package:flutter/material.dart';

import '../../../app_model/process_model/attachment_model.dart';
import '../../../inactivitytimer.dart';
import '../../../service/attachment_list.dart';

class AttachmentListPage extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  const AttachmentListPage({Key? key, required this.inactivityTimerNotifier, required this.graceTimerNotifier}) : super(key: key);

  @override
  _AttachmentListPageState createState() => _AttachmentListPageState();
}

class _AttachmentListPageState extends State<AttachmentListPage> {
  late Future<List<Attachment>> futureAttachments;

  @override
  void initState() {
    super.initState();
    futureAttachments = fetchAttachments();
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ Scaffold(
        appBar: AppBar(
          title: const Text('Attachment List'),
        ),
        body: Center(
          child: FutureBuilder<List<Attachment>>(
            future: futureAttachments,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Attachment> attachments = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Attachment RSN')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Code')),
                        DataColumn(label: Text('Type')),
                      ],
                      rows: attachments.map((attachment) {
                        return DataRow(cells: [
                          DataCell(Text(attachment.attachmentRSN.toString())),
                          DataCell(Text(attachment.attachmentDesc)),
                          DataCell(Text(attachment.attachmentStatusDesc.isNotEmpty ? attachment.attachmentStatusDesc : 'N/A')),
                          DataCell(Text(attachment.attachmentCode.toString())),
                          DataCell(Text(attachment.attachmentTypeDesc)),
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
