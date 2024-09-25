

//
// import 'dart:convert';
// import 'package:autologout_biometric/service/deviceid/deviceid_imei.dart';
// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';  // Import url_launcher
//
// class BiometricService {
//   final LocalAuthentication _localAuth = LocalAuthentication();
//
//   Future<void> enableBiometric(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     final hasBiometricEnabled = prefs.getBool('biometricEnabled') ?? false;
//
//     if (hasBiometricEnabled) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Biometric login is already enabled.')),
//         );
//       }
//       return;
//     }
//
//     final lid = prefs.getString('lid') ?? '';
//     final token = "ABCD1";
//     final deviceID = await getDeviceId()?.toString() ?? '';
//     final imei = deviceID;
//
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
//
//             if (data['isSuccess']) {
//               final bioToken = data['bioToken']?.toString() ?? '';
//
//               if (bioToken.isNotEmpty) {
//                 final userId = prefs.getString('validUserId') ?? '';
//
//                 if (userId.isNotEmpty) {
//                   await prefs.setString('userid', userId);
//                   await prefs.setString('deviceid', deviceID);
//                   await prefs.setString('biotoken', bioToken);
//                   await prefs.setBool('biometricEnabled', true);
//                   print("Biometric info saved successfully.");
//
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Biometric login has been enabled.')),
//                     );
//                   }
//                 } else {
//                   print("Error: validUserId is null.");
//                 }
//               } else {
//                 print('Error: bioToken is not a valid string.');
//                 if (context.mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Invalid biometric token received.')),
//                   );
//                 }
//               }
//             } else {
//               print("Failed to enable biometric: ${data['message']}");
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Failed to enable biometric: ${data['message']}')),
//                 );
//               }
//             }
//           } else {
//             print("Error: ${response.statusCode} - ${response.body}");
//             if (context.mounted) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Server error: ${response.statusCode}')),
//               );
//             }
//           }
//         } else {
//           print("Biometric setup declined by user.");
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Biometric setup was cancelled.')),
//             );
//
//             // Option to open device settings
//             showGoToSettingsDialog(context);
//           }
//         }
//       } catch (e) {
//         print("Error during biometric setup: $e");
//         if (context.mounted) {
//           // ScaffoldMessenger.of(context).showSnackBar(
//           //   const SnackBar(content: Text('An error occurred during biometric setup.')),
//           // );
//
//           // Option to open device settings
//           showGoToSettingsDialog(context);
//         }
//       }
//     } else {
//       print("Error: lid is null or empty.");
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User ID is missing. Cannot enable biometric.')),
//         );
//       }
//     }
//   }
//
//   // Function to open device settings
//   Future<void> openDeviceSettings() async {
//     const urlString = 'App-Prefs:root=';
//     final url = Uri.parse(urlString); // Convert to Uri
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       throw 'Could not launch $urlString';
//     }
//   }
//
//   // Dialog to ask if the user wants to open settings
//   void showGoToSettingsDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Go to Settings'),
//           content: const Text('Please Enable Biometric'),
//           // actions: [
//           //   TextButton(
//           //     onPressed: () {
//           //       Navigator.of(context).pop(); // Close the dialog
//           //     },
//           //     child: const Text('Cancel'),
//           //   ),
//           //   TextButton(
//           //     onPressed: () {
//           //       Navigator.of(context).pop(); // Close the dialog
//           //       openDeviceSettings(); // Open settings
//           //     },
//           //     child: const Text('Go to Settings'),
//           //   ),
//           // ],
//         );
//       },
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:autologout_biometric/service/deviceid/deviceid_imei.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';
class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> enableBiometric(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasBiometricEnabled = prefs.getBool('biometricEnabled') ?? false;

    if (hasBiometricEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric login is already enabled.')),
        );
      }
      return;
    }

    final lid = prefs.getString('lid') ?? '';
    const token = "ABCD1"; // This is just a placeholder
    final deviceID = getDeviceId().toString();
    final imei = deviceID; // Assuming IMEI is same as deviceID

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
              final bioToken = data['bioToken']?.toString() ?? '';

              if (bioToken.isNotEmpty) {
                final userId = prefs.getString('validUserId') ?? '';

                if (userId.isNotEmpty) {
                  await prefs.setString('userid', userId);
                  await prefs.setString('deviceid', deviceID);
                  await prefs.setString('biotoken', bioToken);
                  await prefs.setBool('biometricEnabled', true);
                  print("Biometric info saved successfully.");

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Biometric login has been enabled.')),
                    );
                  }
                } else {
                  print("Error: validUserId is null.");
                }
              } else {
                print('Error: bioToken is not a valid string.');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid biometric token received.')),
                  );
                }
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
              const SnackBar(content: Text('Biometric setup was cancelled.')),
            );

            // Option to open device settings
            showGoToSettingsDialog(context);
          }
        }
      } catch (e) {
        print("Error during biometric setup: $e");
        if (context.mounted) {
          // Option to open device settings
          showGoToSettingsDialog(context);
        }
      }
    } else {
      print("Error: lid is null or empty.");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID is missing. Cannot enable biometric.')),
        );
      }
    }
  }

  // Function to open device settings (iOS or Android)
  Future<void> openDeviceSettings() async {
    try {
      if (Platform.isAndroid) {
        const intent =  AndroidIntent(
          action: 'android.settings.SECURITY_SETTINGS', // Opens Security Settings on Android
        );
        await intent.launch();
      }
      else if (Platform.isIOS) {
        const url = 'app-settings:'; // Opens the app settings on iOS
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          print('Could not launch iOS settings');
        }
      }
    } catch (e) {
      print('Error opening device settings: $e');
    }
  }

  // Dialog to ask if the user wants to open settings
  void showGoToSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Go to Settings'),
          content: const Text('Please enable biometric authentication in your device settings.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                openDeviceSettings(); // Open device settings
              },
              child: const Text('Go to Settings'),
            ),
          ],
        );
      },
    );
  }
}
