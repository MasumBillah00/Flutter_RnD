import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData icon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.amber[200],
          fontWeight: FontWeight.bold,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.amber[200],
        ),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.amber.shade200,
            width: 3.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.amber.shade200,
            width: 2.0,
          ),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.amber.shade200,
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }
}