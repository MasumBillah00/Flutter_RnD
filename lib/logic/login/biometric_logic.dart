
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../service/deviceid/deviceid_imei.dart';

// Check if the device supports biometrics
Future<void> checkBiometrics() async {
  final LocalAuthentication _localAuth = LocalAuthentication();
  try {
    final isAvailable = await _localAuth.canCheckBiometrics;
    if (!isAvailable) {
      print('Biometric authentication not available.');
    } else {
      print('Biometric authentication available.');
    }
  } catch (e) {
    print('Error checking biometrics: $e');
  }
}

// Prompts the user to set up biometrics if not enabled
Future<void> promptBiometricSetup(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final hasBiometricEnabled = prefs.getBool('biometricEnabled') ?? false;
  final hasDeclinedBiometric = prefs.getBool('biometricDeclined') ?? false;
  final hasBeenPrompted = prefs.getBool('biometricPrompted') ?? false;

  print('Biometric Setup: Enabled=$hasBiometricEnabled, Declined=$hasDeclinedBiometric, Prompted=$hasBeenPrompted');

  if (!hasBiometricEnabled && !hasDeclinedBiometric && !hasBeenPrompted) {
    final _localAuth = LocalAuthentication();
    final shouldEnable = await _localAuth.canCheckBiometrics;
    if (shouldEnable) {
      try {
        final enabled = await _localAuth.authenticate(
          localizedReason: 'Enable biometric for future logins',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (enabled) {
          await _enableBiometric(context);
        } else {
          print('User declined biometric setup');
          await prefs.setBool('biometricDeclined', true);
        }
      } catch (e) {
        print("Error during biometric setup: $e");
      }
      await prefs.setBool('biometricPrompted', true);
    }
  }
}

// Handles biometric authentication for login
Future<void> authenticate(BuildContext context, LocalAuthentication localAuth) async {
  final prefs = await SharedPreferences.getInstance();
  final savedUserid = prefs.getString('userid');
  final savedDeviceId = prefs.getString('deviceid');
  final savedBiotoken = prefs.getString('biotoken');
  final token = "ABCD1";  // Replace with actual token
  final imei = await savedDeviceId ?? '';

  print('Attempting biometric authentication...');

  if (savedUserid != null && savedDeviceId != null && savedBiotoken != null) {
    try {
      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Please authenticate to log in',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (isAuthenticated) {
        print('Biometric authentication successful');
        final response = await http.post(
          Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/AutoLoginByBiometric'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "token": token,
            "imei": savedDeviceId,
            "userID": savedUserid,
            "deviceID": savedDeviceId,
            "bioToken": savedBiotoken,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['isSuccess']) {
            print('Biometric login API success');
            BlocProvider.of<AuthBloc>(context).add(
              BiometricLoginEvent(savedUserid, savedDeviceId, savedBiotoken, token, imei),
            );
          } else {
            print('Biometric login API failed: ${data['message']}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data['message'] ?? 'Biometric login failed')),
            );
          }
        } else {
          print('Failed to authenticate: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to authenticate: ${response.body}')),
          );
        }
      } else {
        print('Authentication failed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
      }
    } catch (e) {
      print('Error during authentication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication error occurred')),
      );
    }
  } else {
    print('No saved biometric credentials found');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No saved biometric credentials found')),
    );
  }
}

// Enables biometric login by making an API call
Future<void> _enableBiometric(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final lid = prefs.getString('lid') ?? '';
  if (lid.isNotEmpty) {
    //final imei = "D237DBC1-D0A6-4FB8-8E45-21C0785BB63E";
    //final deviceID = "D237DBC1-D0A6-4FB8-8E45-21C0785BB63E";
    final deviceID = await getDeviceId() ?? '';
    final imei = deviceID;

    final response = await http.post(
      Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/EnableBiometric'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": "ABCD1",
        "imei": imei,
        "lid": lid,
        "deviceID": deviceID,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['isSuccess']) {
        final bioToken = data['bioToken'];
        final userId = prefs.getString('validUserId') ?? '';
        if (userId.isNotEmpty) {
          await _storeBiometricInfo(userId, deviceID, bioToken);
          await prefs.setBool('biometricEnabled', true);
          print("Biometric option enabled successfully");
        } else {
          print("Error: validUserId is null. Biometric info not saved.");
        }
      } else {
        print("Failed to enable biometric: ${data['message']}");
      }
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
    }
  } else {
    print("Error: lid is null or empty.");
  }
}

// Stores biometric info locally
Future<void> _storeBiometricInfo(String userId, String deviceId, String biotoken) async {
  final prefs = await SharedPreferences.getInstance();
  print("Saving biometric info: $userId, $deviceId, $biotoken");
  await prefs.setString('userid', userId);
  await prefs.setString('deviceid', deviceId);
  await prefs.setString('biotoken', biotoken);
}
