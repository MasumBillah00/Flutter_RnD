

import 'package:autologout_biometric/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../service/home_biometric_service.dart';

class CustomDrawer extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  const CustomDrawer({Key? key,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .6,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 110,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Card(
              elevation: 4,
              color: Colors.white.withOpacity(.9),
              child: ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Landing_Page(
                        inactivityTimerNotifier: widget.inactivityTimerNotifier,
                        graceTimerNotifier: widget.graceTimerNotifier,
                      ),

                      ), //
                          (Route<dynamic> route) => false,
                    );
                  }
              ),
            ),
            Card(
              elevation: 4,
              color: Colors.white.withOpacity(.9),
              child: ListTile(
                leading: Icon(Icons.fingerprint, color: Colors.green.shade900),
                title: const Text('Enable Biometric'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  BiometricService().enableBiometric(context); // Pass context here
                },
              ),
            ),
            Card(
              elevation: 4,
              color: Colors.white.withOpacity(.9),
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  BlocProvider.of<AuthBloc>(context).add(AutoLogoutEvent()); // Trigger logout
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
