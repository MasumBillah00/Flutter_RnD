
import 'package:autologout_biometric/bmi_calculator/screen/input_page.dart';
import 'package:autologout_biometric/bottom_sheet/screens/bottom_sheet_home.dart';
import 'package:autologout_biometric/fitness_tracker/view/screen/home_screen.dart';
import 'package:autologout_biometric/screens/home_page/drawer.dart';
import 'package:autologout_biometric/screens/home_page/home_page.dart';
import 'package:autologout_biometric/screens/loginpage.dart';
import 'package:autologout_biometric/todo_app/view/todo_app_screen/todo_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';
import 'inactivitytimer.dart';

class Landing_Page extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;


  Landing_Page({super.key, required this.inactivityTimerNotifier, required this.graceTimerNotifier});

  @override
  State<Landing_Page> createState() => _Landing_PageState();
}

class _Landing_PageState extends State<Landing_Page> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


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
          child: Stack(
            children: [
              Scaffold(
                key: _scaffoldKey,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(90), // Increase the AppBar height
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: ClipRRect(
                      // borderRadius: const BorderRadius.only(
                      //   bottomLeft: Radius.circular(20), // Apply radius to bottom corners
                      //   bottomRight: Radius.circular(20),
                      // ),
                      child: AppBar(

                        title: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 33), // Adjust padding to vertically center the title
                            child: Text(
                              'Flutter R&D',
                              style: TextStyle(
                                fontSize: 24, // Adjust font size if needed
                              ),

                            ),

                          ),
                        ),
                        flexibleSpace: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue
                            // gradient: LinearGradient(
                            //   colors: [Colors.blue, Colors.greenAccent], // Add a gradient for more style
                            //   begin: Alignment.centerRight,
                            //   end: Alignment.centerLeft,
                            // ),
                          ),
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {
                             _scaffoldKey.currentState?.openDrawer(); // Open the drawer when pressed
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                drawer: CustomDrawer(
                  inactivityTimerNotifier: widget.inactivityTimerNotifier,
                  graceTimerNotifier: widget.graceTimerNotifier,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(2.0),

                  child: SingleChildScrollView(
                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Process_HomePage(
                                        inactivityTimerNotifier: widget.inactivityTimerNotifier,
                                        graceTimerNotifier: widget.graceTimerNotifier,
                                      ),
                                    ),
                                  );
                                },
                                child:  Card(
                                  elevation: 4,
                                  color: Colors.blue.shade300,
                                  child: const SizedBox(
                                    height: 230,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.list, size: 70, color: Colors.black), // Process icon
                                        SizedBox(height: 10),
                                        Text(
                                          'Process Details',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8), // Add space between cards
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                        inactivityTimerNotifier: widget.inactivityTimerNotifier,
                                        graceTimerNotifier: widget.graceTimerNotifier,
                                      ),
                                    ),
                                  );
                                },
                                child: const Card(
                                  elevation: 4,
                                  color: Colors.greenAccent,
                                  child: SizedBox(
                                    height: 230,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.fitness_center, size: 70, color: Colors.black), // Fitness icon
                                        SizedBox(height: 10),
                                        Text(
                                          'Your Fitness',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Bottom_Sheet_Home(),
                                    ),
                                  );
                                },
                                child: const Card(
                                  elevation: 4,
                                  color: Colors.greenAccent,
                                  child: SizedBox(
                                    height: 230,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.menu, size: 70, color: Colors.black), // Bottom Sheet icon
                                        SizedBox(height: 10),
                                        Text(
                                          'Bottom Sheet',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8), // Add space between cards
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ToDoAppScreen(
                                        inactivityTimerNotifier: widget.inactivityTimerNotifier,
                                        graceTimerNotifier: widget.graceTimerNotifier,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  color: Colors.blue.shade300,
                                  shadowColor: Colors.black87,
                                  child: const SizedBox(
                                    height: 230,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check_circle, size: 70, color: Colors.black), // To-Do icon
                                        SizedBox(height: 10),
                                        Text(
                                          'TODO',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InputPage(),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 4,
                                    color: Colors.blue.shade300,
                                    shadowColor: Colors.black87,
                                    child: const SizedBox(
                                      height: 230,
                                      width: 160,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.calculate, size: 70, color: Colors.black), // BMI icon
                                          SizedBox(height: 10),
                                          Text(
                                            'BMI',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Bottom_Sheet_Home(),
                                    ),
                                  );
                                },
                                child: const Card(
                                  elevation: 4,
                                  color: Colors.greenAccent,
                                  child: SizedBox(
                                    height: 230,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.menu, size: 70, color: Colors.black), // Bottom Sheet icon
                                        SizedBox(height: 10),
                                        Text(
                                          'Bottom Sheet',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 70,
                right: 10,
                child: TimerDisplay(
                  inactivityTimerNotifier: widget.inactivityTimerNotifier,
                  graceTimerNotifier: widget.graceTimerNotifier,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
