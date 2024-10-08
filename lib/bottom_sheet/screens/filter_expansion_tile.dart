import 'package:flutter/material.dart';

class ExpansionTiles extends StatefulWidget {
  final List<String> selectedFilters;
  final Function(String) onFilterToggle;
  final TextEditingController locationController;
  final String? selectedActivity;
  final Function(String) onActivitySelect;

  const ExpansionTiles({
    super.key,
    required this.selectedFilters,
    required this.onFilterToggle,
    required this.locationController,
    required this.selectedActivity,
    required this.onActivitySelect,
  });

  @override
  ExpansionTilesState createState() => ExpansionTilesState();
}

class ExpansionTilesState extends State<ExpansionTiles> {
  bool isSpot1Checked = false;
  bool isSpot2Checked = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          children: [
            ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.access_time_filled, color: Color.fromARGB(255, 207, 165, 18)),
                  SizedBox(width: 5),
                  Text('When', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
              tilePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8), // Reduced horizontal padding
              children: [
                ListTile(
                  title: const Text('Today'),
                  dense: true,
                  onTap: () {
                    widget.onFilterToggle('Today');
                  },
                ),
                ListTile(
                  title: const Text('Tomorrow'),
                  dense: true,
                  onTap: () {
                    widget.onFilterToggle('Tomorrow');
                  },
                ),
              ],
            ),
            const Divider(thickness: 1, height: 0), // Set the height to 0 to reduce spacing

            // "Where" ExpansionTile with input field and submit button
            ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue),
                  SizedBox(width: 5),
                  Text('Where', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
              tilePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8), // Reduced horizontal padding
              children: [
                ListTile(
                  title: TextField(
                    controller: widget.locationController,
                    decoration: const InputDecoration(
                      labelText: 'Enter location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ListTile(
                  title: ElevatedButton(
                    onPressed: () {
                      if (widget.locationController.text.isNotEmpty) {
                        widget.onFilterToggle('location: ${widget.locationController.text}');
                        widget.locationController.clear();
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1, height: 0), // Reduced height to 0

            // "Who" ExpansionTile
            ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.person_search_rounded, color: Colors.black),
                  SizedBox(width: 5),
                  Text('Who', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
              tilePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8), // Reduced horizontal padding
              children: [
                ListTile(
                  title: const Text('Person 1'),
                  dense: true,
                  onTap: () {
                    widget.onFilterToggle('Person 1');
                  },
                ),
                ListTile(
                  title: const Text('Person 2'),
                  dense: true,
                  onTap: () {
                    widget.onFilterToggle('Person 2');
                  },
                ),
              ],
            ),
            const Divider(thickness: 1, height: 0), // Reduced height to 0

            // "Activities" ExpansionTile
            ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.event_note_outlined, color: Color.fromARGB(255, 134, 99, 42)),
                  SizedBox(width: 5),
                  Text('Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
              tilePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8), // Reduced horizontal padding
              children: [
                RadioListTile<String>(
                  title: const Text('Activity 1'),
                  value: 'Activity 1',
                  groupValue: widget.selectedActivity,
                  onChanged: (String? value) {
                    setState(() {
                      widget.onActivitySelect(value!);
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Activity 2'),
                  value: 'Activity 2',
                  groupValue: widget.selectedActivity,
                  onChanged: (String? value) {
                    setState(() {
                      widget.onActivitySelect(value!);
                    });
                  },
                ),
              ],
            ),
            const Divider(thickness: 1, height: 0), // Reduced height to 0

            // "Spot" ExpansionTile with checkboxes
            ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.local_activity, color: Color.fromARGB(255, 76, 175, 80)),
                  SizedBox(width: 5),
                  Text('Spot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
              tilePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8), // Reduced horizontal padding
              children: [
                CheckboxListTile(
                  title: const Text('Spot 1'),
                  value: isSpot1Checked,
                  onChanged: (bool? value) {
                    setState(() {
                      isSpot1Checked = value ?? false;
                      widget.onFilterToggle('Spot 1');
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: const Text('Spot 2'),
                  value: isSpot2Checked,
                  onChanged: (bool? value) {
                    setState(() {
                      isSpot2Checked = value ?? false;
                      widget.onFilterToggle('Spot 2');
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
