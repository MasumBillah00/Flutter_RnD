import 'package:autologout_biometric/bottom_sheet/screens/bottom_sheet_home.dart';
import 'package:autologout_biometric/fitness_tracker/view/screen/home_screen.dart';
import 'package:autologout_biometric/screens/home_page/home_page.dart';
import 'package:flutter/material.dart';

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
      child: Scaffold(
        appBar: AppBar(
          title: Text('All in One'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to HomePage, passing the timer notifiers
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
                      color: Colors.greenAccent,
                      child: Container(
                        height: 160,
                        width: 160,
                        child: const Center(
                            child: Text(
                          'Process Details',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // // Navigate to HomePage, passing the timer notifiers
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>const Bottom_Sheet_Home (
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      color: Colors.greenAccent,
                      child: Container(
                        height: 160,
                        width: 160,
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Bottom Sheet',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  // // Navigate to HomePage, passing the timer notifiers
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>const HomeScreen (
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  color: Colors.greenAccent,
                  child: Container(
                    height: 160,
                    width: 160,
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Your Fitness',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
