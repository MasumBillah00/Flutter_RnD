import 'package:flutter/material.dart';
import 'process_details.dart';

class ProcessList extends StatelessWidget {
  final List<dynamic> processList;
  final int? selectedIndex;
  final ValueChanged<int?> onSelect;

  const ProcessList({
    required this.processList,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: processList.length,
      itemBuilder: (context, index) {
        final process = processList[index];
        final isSelected = selectedIndex == index;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(process['processDesc'] ?? 'No Description'),
              onTap: () => onSelect(isSelected ? null : index),
            ),
            if (isSelected)
              ProcessDetails(process: process), // Using a separate widget
          ],
        );
      },
    );
  }
}
