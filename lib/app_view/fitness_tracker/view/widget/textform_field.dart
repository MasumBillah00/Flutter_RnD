
import 'package:flutter/material.dart';

class WorkoutTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  const WorkoutTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        readOnly: readOnly,
        keyboardType: readOnly ? null : TextInputType.number,
        onChanged: onChanged,
      ),
    );
  }
}
