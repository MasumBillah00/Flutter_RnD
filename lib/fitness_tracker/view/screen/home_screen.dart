
import 'package:autologout_biometric/fitness_tracker/view/screen/workout_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/drawer_widget.dart';
import '../progress/caloris_progress.dart';
import '../stats/stats.dart';
import 'workout_list.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of pages to navigate between
  final List<Widget> _pages = [
    const WorkoutCalculator(),
    const WorkoutList(),
    const StatsPage(),
    //const TotalWorkoutStats(),
    const ProgressChart(),
    // Assuming WorkoutList is a page to display workout details
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: (){
      //   // Reset inactivity timer on any tap
      //   context.read<AuthBloc>().resetInactivityTimer();
      // },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Fitness Tracker'),


          ),
          drawer: Fitness_Drawer(onItemTapped: _onItemTapped),
          body: _pages[_selectedIndex], // Display the selected page
          bottomNavigationBar: BottomNavigationBar(
            items:  [
              BottomNavigationBarItem(
                icon: Icon(Icons.home,
                  size: 30,
                  color: Colors.greenAccent.shade400,        // Icon color
                  semanticLabel: 'Stats', // Accessible label for screen readers
                  textDirection: TextDirection.ltr,  // Text direction for the icon
                  shadows: const [
                    Shadow(
                      offset: Offset(3.0, 3.0), // Shadow position
                      blurRadius: 3.0,          // Shadow blur radius
                      color: Colors.black45,     // Shadow color
                    ),
                  ],
                ),

                label: 'Home',
              ),

              BottomNavigationBarItem(

                icon: Icon(Icons.library_books,size: 30,
                  color: Colors.greenAccent.shade400,        // Icon color
                  semanticLabel: 'Stats', // Accessible label for screen readers
                  textDirection: TextDirection.ltr,  // Text direction for the icon
                  shadows: const [
                    Shadow(
                      offset: Offset(3.0, 3.0), // Shadow position
                      blurRadius: 3.0,          // Shadow blur radius
                      color: Colors.black45,     // Shadow color
                    ),
                  ],
                ),
                label: 'Workouts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart,size: 30,
                  color: Colors.greenAccent.shade400,        // Icon color
                  semanticLabel: 'Stats', // Accessible label for screen readers
                  textDirection: TextDirection.ltr,  // Text direction for the icon
                  shadows: const [
                    Shadow(
                      offset: Offset(3.0, 3.0), // Shadow position
                      blurRadius: 3.0,          // Shadow blur radius
                      color: Colors.black45,     // Shadow color
                    ),
                  ],
                ),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.query_stats,size: 30,
                  color: Colors.greenAccent.shade400,        // Icon color
                  semanticLabel: 'Stats', // Accessible label for screen readers
                  textDirection: TextDirection.ltr,  // Text direction for the icon
                  shadows: const [
                    Shadow(
                      offset: Offset(3.0, 3.0), // Shadow position
                      blurRadius: 3.0,          // Shadow blur radius
                      color: Colors.black45,     // Shadow color
                    ),
                  ],
                ),
                label: 'Progress',
              ),

            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.blueGrey, // Set background color
            selectedItemColor: Colors.amber, // Color of selected icon and label
            unselectedItemColor: Colors.white70, // Color of unselected icons and labels
            showUnselectedLabels: true, // Show labels for unselected items
            type: BottomNavigationBarType.fixed, // Ensures the text and icons remain at a fixed size
            elevation: 10, // Add a shadow to the bar
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
