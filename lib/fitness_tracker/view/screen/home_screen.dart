import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth_bloc.dart';
import '../../../bloc/auth_state.dart';
import '../../../inactivitytimer.dart';
import '../../../screens/loginpage.dart';
import '../../widget/drawer_widget.dart';
import '../progress/caloris_progress.dart';
import '../stats/stats.dart';
import 'workout_calculator.dart';
import 'workout_list.dart';

class HomeScreen extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  const HomeScreen({
    super.key,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  // List of pages to navigate between
  // final List<Widget> _pages =  [
  //   WorkoutCalculator(
  //     inactivityTimerNotifier: widget.inactivityTimerNotifier,
  //     graceTimerNotifier: widget.graceTimerNotifier,
  //   ),
  //   WorkoutList(),
  //   StatsPage(),
  //   ProgressChart(),
  // ];
  void initState() {
    super.initState();

    // Initialize the pages in `initState` where `widget` can be accessed
    _pages = [
      WorkoutCalculator(
        inactivityTimerNotifier: widget.inactivityTimerNotifier,
        graceTimerNotifier: widget.graceTimerNotifier,
      ),
      const WorkoutList(),
      const StatsPage(),
      const ProgressChart(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
      return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (mounted && state is LoggedOutState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage(
                inactivityTimerNotifier: widget.inactivityTimerNotifier,
                graceTimerNotifier: widget.graceTimerNotifier,
              )),
            );
          }
        },
      child: InactivityListener(
        inactivityTimerNotifier: widget.inactivityTimerNotifier,
        graceTimerNotifier: widget.graceTimerNotifier,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Fitness Tracker'),
            ),
            drawer: Fitness_Drawer(
              onItemTapped: _onItemTapped,
              inactivityTimerNotifier: widget.inactivityTimerNotifier,
              graceTimerNotifier: widget.graceTimerNotifier,
            ),
            body: Stack(children: [
              _pages[_selectedIndex],

              Positioned(
                bottom: 0,
                right: 10,
                child: TimerDisplay(
                  inactivityTimerNotifier: widget.inactivityTimerNotifier,
                  graceTimerNotifier: widget.graceTimerNotifier,
                ),
              ),

            ],),
            // Display the selected page
            bottomNavigationBar: BottomNavigationBar(
              items: [
                _buildBottomNavigationBarItem(Icons.home, 'Home'),
                _buildBottomNavigationBarItem(Icons.library_books, 'Workouts'),
                _buildBottomNavigationBarItem(Icons.bar_chart, 'Stats'),
                _buildBottomNavigationBarItem(Icons.query_stats, 'Progress'),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: Colors.blueGrey, // Set background color
              selectedItemColor: Colors.amber, // Color of selected icon and label
              unselectedItemColor: Colors.white70, // Color of unselected icons and labels
              showUnselectedLabels: true, // Show labels for unselected items
              type: BottomNavigationBarType.fixed, // Ensures text and icons remain fixed size
              elevation: 10, // Adds a shadow to the bar
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: 30,
        color: Colors.greenAccent.shade400,
        shadows: const [
          Shadow(
            offset: Offset(3.0, 3.0), // Shadow position
            blurRadius: 3.0, // Shadow blur radius
            color: Colors.black45, // Shadow color
          ),
        ],
      ),
      label: label,
    );
  }
}
