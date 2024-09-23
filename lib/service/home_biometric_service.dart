
import 'dart:convert';
import 'package:flutter/material.dart'; // Import this for showing SnackBar
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> enableBiometric(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasBiometricEnabled = prefs.getBool('biometricEnabled') ?? false;

    if (hasBiometricEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Biometric login is already enabled.')),
        );
      }
      return;
    }

    final lid = prefs.getString('lid') ?? '';
    final token = "ABCD1";
    final imei = "D237DBC1-D0A6-4FB8-8E45-21C0785BB63E";
    final deviceID = imei;

    if (lid.isNotEmpty) {
      try {
        final enabled = await _localAuth.authenticate(
          localizedReason: 'Enable biometric for future logins',
          options: const AuthenticationOptions(biometricOnly: true),
        );

        if (enabled) {
          final response = await http.post(
            Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/EnableBiometric'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "token": token,
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
                await prefs.setString('userid', userId);
                await prefs.setString('deviceid', deviceID);
                await prefs.setString('biotoken', bioToken);
                await prefs.setBool('biometricEnabled', true);
                print("Biometric info saved successfully.");

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Biometric login has been enabled.')),
                  );
                }
              } else {
                print("Error: validUserId is null.");
              }
            } else {
              print("Failed to enable biometric: ${data['message']}");
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to enable biometric: ${data['message']}')),
                );
              }
            }
          } else {
            print("Error: ${response.statusCode} - ${response.body}");
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Server error: ${response.statusCode}')),
              );
            }
          }
        } else {
          print("Biometric setup declined by user.");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Biometric setup was cancelled.')),
            );
          }
        }
      } catch (e) {
        print("Error during biometric setup: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred during biometric setup.')),
          );
        }
      }
    } else {
      print("Error: lid is null or empty.");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID is missing. Cannot enable biometric.')),
        );
      }
    }
  }
}


// class BiometricService {
//   final LocalAuthentication _localAuth = LocalAuthentication();
//
//   Future<void> enableBiometric(BuildContext context) async { // Pass context for SnackBar
//     final prefs = await SharedPreferences.getInstance();
//     final hasBiometricEnabled = prefs.getBool('biometricEnabled') ?? false;
//
//     if (hasBiometricEnabled) {
//       // Biometric is already enabled, show a message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Biometric login is already enabled.')),
//       );
//       return; // Exit the method
//     }
//
//     // Proceed to enable biometric as it's not enabled yet
//     final lid = prefs.getString('lid') ?? '';
//     final token = "ABCD1"; // Use the actual token here
//     final imei = "D237DBC1-D0A6-4FB8-8E45-21C0785BB63E"; // Use a dynamic IMEI
//     final deviceID = imei;
//
//     if (lid.isNotEmpty) {
//       try {
//         final enabled = await _localAuth.authenticate(
//           localizedReason: 'Enable biometric for future logins',
//           options: const AuthenticationOptions(biometricOnly: true),
//         );
//
//         if (enabled) {
//           final response = await http.post(
//             Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/EnableBiometric'),
//             headers: {"Content-Type": "application/json"},
//             body: jsonEncode({
//               "token": token,
//               "imei": imei,
//               "lid": lid,
//               "deviceID": deviceID,
//             }),
//           );
//
//           if (response.statusCode == 200) {
//             final data = jsonDecode(response.body);
//             if (data['isSuccess']) {
//               final bioToken = data['bioToken'];
//               final userId = prefs.getString('validUserId') ?? '';
//
//               if (userId.isNotEmpty) {
//                 await prefs.setString('userid', userId);
//                 await prefs.setString('deviceid', deviceID);
//                 await prefs.setString('biotoken', bioToken);
//                 await prefs.setBool('biometricEnabled', true);
//                 print("Biometric info saved successfully.");
//
//                 // Show success message
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Biometric login has been enabled.')),
//                 );
//               } else {
//                 print("Error: validUserId is null.");
//               }
//             } else {
//               print("Failed to enable biometric: ${data['message']}");
//               // Show error message
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Failed to enable biometric: ${data['message']}')),
//               );
//             }
//           } else {
//             print("Error: ${response.statusCode} - ${response.body}");
//             // Show error message
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Server error: ${response.statusCode}')),
//             );
//           }
//         } else {
//           print("Biometric setup declined by user.");
//           // Optionally show a message if needed
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Biometric setup was cancelled.')),
//           );
//         }
//       } catch (e) {
//         print("Error during biometric setup: $e");
//         // Show error message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('An error occurred during biometric setup.')),
//         );
//       }
//     } else {
//       print("Error: lid is null or empty.");
//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('User ID is missing. Cannot enable biometric.')),
//       );
//     }
//   }
// }

