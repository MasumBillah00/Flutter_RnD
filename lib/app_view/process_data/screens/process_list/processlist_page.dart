
import 'package:autologout_biometric/app_view/process_data/screens/process_list/processlist.dart';
import 'package:flutter/material.dart';

import '../../../../service/get_processlist_service.dart';


class GetprocessList extends StatefulWidget {
  const GetprocessList({super.key});

  @override
  _GetprocessListState createState() => _GetprocessListState();
}

class _GetprocessListState extends State<GetprocessList> {
  late Future<List<dynamic>> _processListFuture;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _processListFuture = fetchProcessList(); // Moved fetch logic to a separate file
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _processListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No processes found.'));
          } else {
            final processList = snapshot.data!;
            return ProcessList(
              processList: processList,
              selectedIndex: _selectedIndex,
              onSelect: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            );
          }
        },
      ),
    );
  }
}

