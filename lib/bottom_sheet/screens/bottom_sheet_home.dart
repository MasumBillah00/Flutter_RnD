
import 'package:autologout_biometric/bottom_sheet/screens/bottom_sheet.dart';
import 'package:flutter/material.dart';

class Bottom_Sheet_Home extends StatelessWidget {
  const Bottom_Sheet_Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Bottom Sheet'),
          centerTitle: true,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const FilterBottomSheet(),
              );
            },
            child: const Text('Bottom Sheet'),
          ),
        ),
      ),
    );
  }
}

