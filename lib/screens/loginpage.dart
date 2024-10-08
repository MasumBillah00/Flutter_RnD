import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'package:local_auth/local_auth.dart';
import '../landing_page.dart';
import '../logic/login/biometric_logic.dart';
import '../logic/login/login_logic.dart';
import 'home_page/home_page.dart';

class LoginPage extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  LoginPage({required this.inactivityTimerNotifier, required this.graceTimerNotifier});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    checkBiometrics(); // Moved to `biometric_logic.dart`
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Background2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is LoggedInState) {
                final prefs = await SharedPreferences.getInstance();
                final hasBiometricEnabled = prefs.getBool('biometricEnabled') ?? false;
                final hasBeenPrompted = prefs.getBool('biometricPrompted') ?? false;

                if (!hasBiometricEnabled && !hasBeenPrompted) {
                  await promptBiometricSetup(context); // Moved to `biometric_logic.dart`
                }


                // Navigate to HomePage, passing the timer notifiers
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Landing_Page(
                      inactivityTimerNotifier: widget.inactivityTimerNotifier,
                      graceTimerNotifier: widget.graceTimerNotifier,
                  ),)
                );
              } else if (state is LoginFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: _loginUI(context),
          ),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 75),
              _buildTextField(_usernameController, 'Username', Icons.person),
              const SizedBox(height: 12),
              _buildPasswordField(_passwordController, 'Password', Icons.lock),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  loginUser(context, _usernameController.text, _passwordController.text); // Moved to `login_logic.dart`
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => authenticate(context, _localAuth), // Moved to `biometric_logic.dart`
                child: const Text('Login with Biometrics'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showWarningDialog(context); // Show warning dialog before removing biometric info
                },
                child: const Text('Remove Biometric Information'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blue),
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blue),
        prefixIcon: Icon(icon),
      ),
    );
  }
}



