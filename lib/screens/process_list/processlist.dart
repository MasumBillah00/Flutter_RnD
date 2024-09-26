import 'package:flutter/material.dart';
import 'process_details.dart';

class ProcessList extends StatelessWidget {
  final List<dynamic> processList;
  final int? selectedIndex;
  final ValueChanged<int?> onSelect;
  //final ScrollController _scrollController = ScrollController();


   const ProcessList({super.key,
    required this.processList,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      //controller: _scrollController,
      thumbVisibility: true, // Always show the scrollbar
      thickness: 8.0, // Adjust scrollbar thickness
      radius: const Radius.circular(10), // Make scrollbar rounded
      interactive: true,
      thumbColor:Colors.blue.shade300,



      child: ListView.builder(
        itemCount: processList.length,
        itemBuilder: (context, index) {
          final process = processList[index];
          final isSelected = selectedIndex == index;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16), // Space around the card
                child: ListTile(
                  tileColor: isSelected
                  ? Colors.blue.shade200:Colors.black.withOpacity(.051),
                  iconColor: isSelected
                  ?Colors.black:Colors.blue,
                  shape: isSelected?
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)):RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  leading:Text(
                    '${index + 1}.'.toString(), // Display the number (1-based index)
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.black, // Change color based on selection
                      fontWeight: FontWeight.bold, // Bold for emphasis
                      fontSize: 18, // Adjust font size as needed
                    ),
                  ),

                  title: Text(
                    process['processDesc'] ?? 'No Description',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(
                    isSelected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, // Up/Down arrow
                  ),
                  onTap: () => onSelect(isSelected ? null : index),
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding for details
                  child: ProcessDetails(process: process),
                ),
            ],
          );
        },
      ),
    );
  }
}
