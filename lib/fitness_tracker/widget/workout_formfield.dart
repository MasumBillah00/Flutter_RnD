
import 'package:flutter/material.dart';

class WorkoutFormField extends StatelessWidget {
  final String label;
  final String dropdownValue;
  final ValueChanged<String?> onChanged;

  const WorkoutFormField({
    super.key,
    required this.label,
    required this.dropdownValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: dropdownValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
        items: <String>[
          'Select Workout Type',
          'Running',
          'Walking',
          'PushUP',
          'Endurance'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

// Widget for Text Form Field
