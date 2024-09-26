

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../../inactivitytimer.dart';
import '../loginpage.dart';
import '../process_list/processlist_page.dart';
import 'bottom_nav_bar.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  const HomePage({
    Key? key,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0; // To track the selected tab index
  bool _isLoading = false; // Variable to control loading overlay visibility

  final List<Widget> _pages = [
    GetprocessList(), // Home tab content
    const Center(child: Text('Search Page Content')), // Search tab
    const Center(child: Text('Profile Page Content')), // Profile tab
  ];

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

        if (state is LoadingState) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              appBar: PreferredSize(
                preferredSize:const Size.fromHeight(70),
                child: AppBar(
                  title: const Padding(
                    padding:  EdgeInsets.only(top: 10.0),
                    child:  Text(
                      'Home',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _pages[_currentIndex],
              ), // Display content based on selected tab
              bottomNavigationBar: CustomBottomNav(
                currentIndex: _currentIndex,
                onTap: (index) {
                  if (index == 3) {
                    BlocProvider.of<AuthBloc>(context).add(AutoLogoutEvent()); // Logout
                  } else {
                    setState(() {
                      _currentIndex = index;
                    });
                  }
                },
              ),
              drawer: const CustomDrawer(),
            ),
            // Position the TimerDisplay widget
            Positioned(
              bottom: 100,
              right: 10,
              child: TimerDisplay(
                inactivityTimerNotifier: widget.inactivityTimerNotifier,
                graceTimerNotifier: widget.graceTimerNotifier,
              ),
            ),
            // Show loading overlay if _isLoading is true
            if (_isLoading)
              const LoadingOverlay(),
          ],
        ),
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final String message;

  const LoadingOverlay({Key? key, this.message = 'Log Out...'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              message,
              style:  TextStyle(
                color: Colors.blue.shade500,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
