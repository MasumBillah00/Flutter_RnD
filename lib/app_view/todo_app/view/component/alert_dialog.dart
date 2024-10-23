
import 'package:flutter/material.dart';

void showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel',style: TextStyle(color: Colors.black),),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Delete',style: TextStyle(color: Colors.red),),
          ),
        ],
      );
    },
  );
}
