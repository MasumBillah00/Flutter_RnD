
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../landing_page.dart';

class Fitness_Drawer extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  final ValueChanged<int> onItemTapped;

  const Fitness_Drawer({
    super.key,
    required this.onItemTapped, required this.inactivityTimerNotifier, required this.graceTimerNotifier,
  });

  @override
  State<Fitness_Drawer> createState() => _Fitness_DrawerState();
}

class _Fitness_DrawerState extends State<Fitness_Drawer> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * 0.6,
      child: Drawer(
        child: SizedBox(

          child: Container(



            color: Colors.white.withOpacity(.12),
            child: ListView(
              padding: const EdgeInsets.only(
                right: 5,
                top: 8,
              ),
              children: <Widget>[
                SizedBox(
                  height: 120,
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.circular(13)),
                    child: const Text(
                      'Fitness Tracker',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.blueGrey.shade800,
                  child: ListTile(
                    leading: Container(
                      width: 30, // Set the width and height to control the image size
                      height: 30,

                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/house.png'), // Path to your image
                          fit: BoxFit.contain, // Adjust the image to fit within the container
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black45,  // Shadow color
                        //     blurRadius: 3.0,        // Shadow blur radius
                        //     offset: Offset(3.0, 3.0), // Shadow offset
                        //   ),
                        // ],
                      ),
                    ),
                    title: const Text(
                      'Home',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Landing_Page(
                          inactivityTimerNotifier: widget.inactivityTimerNotifier,
                          graceTimerNotifier: widget.graceTimerNotifier,
                        ),
                        ),
                            (Route<dynamic> route) => false,
                      );
                      //Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                ),
                Card(
                  color: Colors.blueGrey.shade800,
                  child: ListTile(
                    leading: Container(
                      width: 30, // Set the width and height to control the image size
                      height: 30,

                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/documents.png'), // Path to your image
                          fit: BoxFit.contain, // Adjust the image to fit within the container
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black45,  // Shadow color
                        //     blurRadius: 3.0,        // Shadow blur radius
                        //     offset: Offset(3.0, 3.0), // Shadow offset
                        //   ),
                        // ],
                      ),
                    ),
                    title: const Text(
                      'Workout List',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    onTap: () {
                      widget.onItemTapped(1);
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                ),
                Card(
                  color: Colors.blueGrey.shade800,
                  child: ListTile(
                    leading: Container(
                      width: 30, // Set the width and height to control the image size
                      height: 30,

                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/stats.png'), // Path to your image
                          fit: BoxFit.contain, // Adjust the image to fit within the container
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black45,  // Shadow color
                        //     blurRadius: 3.0,        // Shadow blur radius
                        //     offset: Offset(3.0, 3.0), // Shadow offset
                        //   ),
                        // ],
                      ),
                    ),
                    title: const Text(
                      'Stats',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    onTap: () {
                      widget.onItemTapped(2);
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                ),

                // Card(
                //   color: Colors.blueGrey.shade800,
                //   child: ListTile(
                //     leading: Icon(
                //       Icons.bar_chart_outlined,  // Icon data
                //       size: 30.0,                // Icon size in logical pixels
                //       color: Colors.greenAccent.shade400,        // Icon color
                //       semanticLabel: 'Stats', // Accessible label for screen readers
                //       textDirection: TextDirection.ltr,  // Text direction for the icon
                //       shadows: const [
                //         Shadow(
                //           offset: Offset(3.0, 3.0), // Shadow position
                //           blurRadius: 3.0,          // Shadow blur radius
                //           color: Colors.black45,     // Shadow color
                //         ),
                //       ],
                //     ),

                //     title: const Text(
                //       'Stats',
                //       style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
                //     ),
                //     onTap: () {
                //       onItemTapped(2);
                //       Navigator.of(context).pop(); // Close the drawer
                //     },
                //   ),
                // ),

                Card(
                  color: Colors.blueGrey.shade800,
                  child: ListTile(
                    leading: Container(
                      width: 30, // Set the width and height to control the image size
                      height: 30,

                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/progress.png'), // Path to your image
                          fit: BoxFit.contain, // Adjust the image to fit within the container
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black45,  // Shadow color
                        //     blurRadius: 3.0,        // Shadow blur radius
                        //     offset: Offset(3.0, 3.0), // Shadow offset
                        //   ),
                        // ],
                      ),
                    ),
                    title: const Text(
                      'Progress',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    onTap: () {
                      widget.onItemTapped(3);
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Card(
                //   color: Colors.blueGrey.shade800,
                //   child: ListTile(
                //     leading: Container(
                //       width: 30,
                //       height: 30,
                //       decoration: const BoxDecoration(
                //         image: DecorationImage(
                //           image: AssetImage('assets/icons/logout.png'),
                //           fit: BoxFit.contain,
                //         ),
                //       ),
                //     ),
                //     title: const Text(
                //       'Logout',
                //       style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
                //     ),
                //     onTap: () {
                //       context.read<AuthBloc>().add(LogoutEvent()); // Trigger the Logout event
                //       Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false); // Navigate to the login screen
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}