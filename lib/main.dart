
import 'package:autologout_biometric/screens/home_page/home_page.dart';
import 'package:autologout_biometric/screens/loginpage.dart';
import 'package:autologout_biometric/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';
import 'inactivitytimer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final inactivityTimerNotifier = ValueNotifier<int>(100);
  final graceTimerNotifier = ValueNotifier<int>(60);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: InactivityListener(
        inactivityTimerNotifier: inactivityTimerNotifier,
        graceTimerNotifier: graceTimerNotifier,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Auto Logout App',
          theme: AppTheme.lightTheme,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is LoggedInState) {
                return HomePage(
                  inactivityTimerNotifier: inactivityTimerNotifier,
                  graceTimerNotifier: graceTimerNotifier,
                );
              } else {
                return LoginPage(
                  inactivityTimerNotifier: inactivityTimerNotifier,
                  graceTimerNotifier: graceTimerNotifier,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
