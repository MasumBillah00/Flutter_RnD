import 'package:flutter/material.dart';

class KeyWordDisplay extends StatefulWidget {
  final List<String> selectedFilters;
  final Map<String, Map<String, dynamic>> filterIconsAndColors;
  final Function(String) onFilterToggle;

  const KeyWordDisplay({
    super.key,
    required this.selectedFilters,
    required this.filterIconsAndColors,
    required this.onFilterToggle,
  });



  @override
  State<KeyWordDisplay> createState() => _KeyWordDisplayState();
}

class _KeyWordDisplayState extends State<KeyWordDisplay> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: widget.selectedFilters.map((filter) {
        final filterIcon = filter.contains('location') ? Icons.location_on
            : widget.filterIconsAndColors[filter]?['icon'] ?? Icons.help_outline;

        final filterColor = filter.contains('location') ? Colors.blue
            : widget.filterIconsAndColors[filter]?['color'] ?? Colors.grey;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filterIcon,
                    color: filterColor,
                  ),
                  const SizedBox(width: 8),
                  Text(filter.replaceFirst('location: ', '')), // Remove the prefix for display
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
                    onPressed: () {
                      widget.onFilterToggle(filter);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              onSelected: (bool selected) {
                widget.onFilterToggle(filter);
              },
              backgroundColor: const Color.fromARGB(255, 255, 236, 179)),
        );
      }).toList(),
    );
  }
}
