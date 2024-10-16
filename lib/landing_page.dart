import 'package:autologout_biometric/bmi_calculator/screen/input_page.dart';
import 'package:autologout_biometric/bottom_sheet/screens/bottom_sheet_home.dart';
import 'package:autologout_biometric/fitness_tracker/view/screen/home_screen.dart';
import 'package:autologout_biometric/screens/home_page/home_page.dart';
import 'package:autologout_biometric/todo_app/view/todo_app_screen/todo_app_screen.dart';
import 'package:flutter/material.dart';
import 'inactivitytimer.dart';

class Landing_Page extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;
  Landing_Page({super.key, required this.inactivityTimerNotifier, required this.graceTimerNotifier});

  @override
  State<Landing_Page> createState() => _Landing_PageState();
}

class _Landing_PageState extends State<Landing_Page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(90), // Increase the AppBar height
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                child: AppBar(
                  title: const Center(
                    child: Padding(
                      padding:  EdgeInsets.only(top: 33), // Adjust padding to vertically center the title
                      child:  Text(
                        'Flutter R&D',
                        style: TextStyle(
                          fontSize: 24, // Adjust font size if needed
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: Container(
                    decoration:  BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.blue.shade700], // Add a gradient for more style
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(2.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    inactivityTimerNotifier: widget.inactivityTimerNotifier,
                                    graceTimerNotifier: widget.graceTimerNotifier,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              color: Colors.blue.shade300,
                              child: const SizedBox(
                                height: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.list, size: 50, color: Colors.black), // Process icon
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
                              child:  SizedBox(
                                height: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.fitness_center, size: 50, color: Colors.black), // Fitness icon
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
                              child:  SizedBox(
                                height: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.menu, size: 50, color: Colors.black), // Bottom Sheet icon
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
                                height: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle, size: 50, color: Colors.black), // To-Do icon
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

                      Padding(
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
                              height: 160,
                              width: 160,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calculate, size: 50, color: Colors.black), // To-Do icon
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
    );
  }
}