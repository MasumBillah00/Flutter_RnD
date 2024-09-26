import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../attachment_content.dart';
import '../attachment_list.dart';
import '../attempt_list.dart';
import '../attempt_reasult_page.dart';
import '../document_content_page.dart';
import '../documents_list_page.dart';

class ProcessDetails extends StatelessWidget {
  final dynamic process;

  const ProcessDetails({required this.process});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date Circle + Main Info
            _buildHeader(context),
            const Divider(height: 20, thickness: 1.5),
            _buildDetailsTable(),
            const SizedBox(height: 10),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      child: Row(
        children: [
          _buildDateCircle(),
          const SizedBox(width: 2),
          Expanded(
            child: Center(
              child: Text(
                process['processDesc'] ?? 'No Description',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCircle() {
    final scheduleDate = process['scheduleDate'];
    final parsedDate = scheduleDate != null ? DateTime.parse(scheduleDate) : null;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Column(
          children: [
            Text(
              parsedDate != null ? DateFormat('MMM d').format(parsedDate) : '',
              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              parsedDate != null ? DateFormat('yyy').format(parsedDate) : '',
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
        },
        children: [
          _buildTableRow('Discipline', process['disciplineDesc']),
          _buildTableRow('Assigned User', process['assignedUser']),
          _buildTableRow('Status', process['statusDesc']),
          _buildTableRow('Address', process['folderNumber']),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(title, style:
          const TextStyle(
              fontWeight: FontWeight.bold,
            color: Colors.black87,

          ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(value ?? '',style: const TextStyle(color: Colors.black),),
        ),
      ],
    );
  }
  Widget _buildActionButtons(BuildContext context) {
    // Buttons for different actions related to the process
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.yellow.shade700,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Process Attempt List Page
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProcessAttemptListPage(
                    processRSN: 2503939, // Replace with dynamic processRSN if needed
                    inactivityTimerNotifier: context.findAncestorWidgetOfExactType<MyApp>()!.inactivityTimerNotifier,
                    graceTimerNotifier: context.findAncestorWidgetOfExactType<MyApp>()!.graceTimerNotifier,
                  ),
                ),
              );
            },
          ),
          // Attempt Result List Page
          IconButton(
            icon: const Icon(Icons.view_list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttemptResultListPage(
                    processRSN: 2503939, // Replace with dynamic processRSN if needed
                    inactivityTimerNotifier: context.findAncestorWidgetOfExactType<MyApp>()!.inactivityTimerNotifier,
                    graceTimerNotifier: context.findAncestorWidgetOfExactType<MyApp>()!.graceTimerNotifier,
                  ),
                ),
              );
            },
          ),
          // Attachment List Page
          IconButton(
            icon: const Icon(Icons.attachment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttachmentListPage(
                    inactivityTimerNotifier: context.findAncestorWidgetOfExactType<MyApp>()!.inactivityTimerNotifier,
                    graceTimerNotifier: context.findAncestorWidgetOfExactType<MyApp>()!.graceTimerNotifier,
                  ),
                ),
              );
            },
          ),
          // Attachment Content Page
          IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttachmentContentPage(
                    attachmentRSN: 113718, // Replace with the actual attachmentRSN
                    inactivityTimerNotifier: context.findAncestorWidgetOfExactType<MyApp>()!.inactivityTimerNotifier,
                    graceTimerNotifier: context.findAncestorWidgetOfExactType<MyApp>()!.graceTimerNotifier,
                  ),
                ),
              );
            },
          ),
          // Document List Page
          IconButton(
            icon: const Icon(Icons.document_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DocumentListPage(
                    inactivityTimerNotifier: context.findAncestorWidgetOfExactType<MyApp>()!.inactivityTimerNotifier,
                    graceTimerNotifier: context.findAncestorWidgetOfExactType<MyApp>()!.graceTimerNotifier,
                  ),
                ),
              );
            },
          ),
          // Document Content Page
          IconButton(
            icon: const Icon(Icons.document_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DocumentContentPage(
                    documentRSN: 150524, // Replace with the actual documentRSN
                    inactivityTimerNotifier: context.findAncestorWidgetOfExactType<MyApp>()!.inactivityTimerNotifier,
                    graceTimerNotifier: context.findAncestorWidgetOfExactType<MyApp>()!.graceTimerNotifier,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
