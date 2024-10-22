

import 'package:flutter/material.dart';
import 'filter_expansion_tile.dart';
import 'filter_header.dart';
import 'filterchip_display.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with SingleTickerProviderStateMixin {
  List<String> selectedFilters = [];
  String? selectedActivity;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<String, Map<String, dynamic>> filterIconsAndColors = {
    'Today': {
      'icon': Icons.access_time_filled,
      'color': const Color.fromARGB(255, 207, 165, 18)
    },
    'Tomorrow': {
      'icon': Icons.access_time_filled,
      'color': const Color.fromARGB(255, 207, 165, 18)
    },
    'Location': {'icon': Icons.location_on, 'color': Colors.blue.shade700},
    'Person 1': {'icon': Icons.person_search_rounded, 'color': Colors.black87},
    'Person 2': {'icon': Icons.person_search_rounded, 'color': Colors.black87},
    'Activity 1': {
      'icon': Icons.event_note_outlined,
      'color': const Color.fromARGB(255, 134, 99, 42)
    },
    'Activity 2': {
      'icon': Icons.event_note_outlined,
      'color': const Color.fromARGB(255, 134, 99, 42)
    },
    'Spot 1': {
      'icon': Icons.local_activity_rounded,
      'color': const Color.fromARGB(255, 76, 175, 80)
    },
    'Spot 2': {
      'icon': Icons.local_activity_rounded,
      'color': const Color.fromARGB(255, 76, 175, 80)
    },
  };

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller and fade animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInSine,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<String> getFilteredItems() {
    if (searchQuery.isEmpty) {
      return [];
    } else {
      return filterIconsAndColors.keys
          .where((filter) =>
          filter.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (selectedFilters.contains(filter)) {
        selectedFilters.remove(filter);
      } else {
        selectedFilters.add(filter);
      }
    });
  }

  void _selectActivity(String activity) {
    setState(() {
      selectedActivity = activity;
      if (!selectedFilters.contains(activity)) {
        selectedFilters.removeWhere((filter) => filter.contains('Activity'));
        selectedFilters.add(activity);
      }
    });
  }

  void _resetFilters() {
    setState(() {
      selectedFilters.clear();
      selectedActivity = null;
      _locationController.clear();
    });
  }

  void _onSearch() {
    setState(() {
      searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = getFilteredItems();

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.7,
        builder: (BuildContext context, ScrollController scrollController) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              thickness: 12,
              radius: const Radius.circular(20),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30, right: 16, left: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                              style: const TextStyle(
                                  fontSize: 14, height: 1, color: Colors.red),
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _onSearch, // Call the search function
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color.fromARGB(255, 13, 117, 164),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                            ),
                            child: const Icon(Icons.search, size: 28),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Filter Header
                      const Header(),
                      const SizedBox(height: 12),

                      if (searchQuery.isNotEmpty) ...[
                        const Text('Search Results',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        filteredItems.isNotEmpty
                            ? Column(
                          children: filteredItems.map((filter) {
                            return ListTile(
                              leading: Icon(
                                  filterIconsAndColors[filter]?['icon']),
                              title: Text(filter),
                              trailing: selectedFilters.contains(filter)
                                  ? Icon(Icons.check, color: Colors.green)
                                  : null,
                              onTap: () => _toggleFilter(filter),
                            );
                          }).toList(),
                        )
                            : const Text('No results found',
                            style: TextStyle(color: Colors.red)),
                        const Divider(thickness: 2, height: 20),
                      ],
                      KeyWordDisplay(
                        selectedFilters: selectedFilters,
                        filterIconsAndColors: filterIconsAndColors,
                        onFilterToggle: _toggleFilter,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: _resetFilters,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color.fromARGB(255, 13, 117, 164),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text('Reset',
                                style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color.fromARGB(255, 13, 117, 164),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                            child: const Text('Search'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 2, height: 0),
                      ExpansionTiles(
                        selectedFilters: selectedFilters,
                        onFilterToggle: _toggleFilter,
                        locationController: _locationController,
                        selectedActivity: selectedActivity,
                        onActivitySelect: _selectActivity,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
