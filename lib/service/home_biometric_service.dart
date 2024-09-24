
import 'dart:convert';
import 'package:autologout_biometric/service/deviceid/deviceid_imei.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';  // Import for opening settings

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
    final token = "ABCD1";
    final imei = await getDeviceId() ?? '';
    final deviceID = await getDeviceId()?.toString() ?? '';  // Ensure deviceID is a string

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
                await prefs.setBool('biometricEnabled', false);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid biometric token received.')),
                  );
                }
              }
            } else {
              await prefs.setBool('biometricEnabled', false);
              print("Failed to enable biometric: ${data['message']}");
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to enable biometric: ${data['message']}')),
                );
              }
            }
          } else {
            await prefs.setBool('biometricEnabled', false);
            print("Error: ${response.statusCode} - ${response.body}");
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Server error: ${response.statusCode}')),
              );
            }
          }
        } else {
          await prefs.setBool('biometricEnabled', false);
          print("Biometric setup declined by user.");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Biometric setup was cancelled.')),
            );
            showGoToSettingsDialog(context);  // Option to go to settings
          }
        }
      } catch (e) {
        await prefs.setBool('biometricEnabled', false);
        print("Error during biometric setup: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An error occurred during biometric setup.')),
          );
          showGoToSettingsDialog(context);  // Option to go to settings
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

  // Function to open device settings
  Future<void> openDeviceSettings() async {
    const urlString = 'App-Prefs:root=';
    final url = Uri.parse(urlString); // Convert to Uri
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $urlString';
    }
  }

  // Dialog to ask if the user wants to open settings
  void showGoToSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Go to Settings'),
          content: const Text('Do you want to open the device settings to configure biometric authentication?'),
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
                openDeviceSettings(); // Open settings
              },
              child: const Text('Go to Settings'),
            ),
          ],
        );
      },
    );
  }
}

//
// jjjjjjj
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
//     final imei = await getDeviceId() ?? '';
//     final deviceID = await getDeviceId()?.toString() ?? '';  // Ensure deviceID is a string
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
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('An error occurred during biometric setup.')),
//           );
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
//           content: const Text('Do you want to open the device settings to configure biometric authentication?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 openDeviceSettings(); // Open settings
//               },
//               child: const Text('Go to Settings'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


//
// import 'dart:convert';
// import 'package:autologout_biometric/service/deviceid/deviceid_imei.dart';
// import 'package:flutter/material.dart'; // Import this for showing SnackBar
// import 'package:local_auth/local_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
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
//           SnackBar(content: Text('Biometric login is already enabled.')),
//         );
//       }
//       return;
//     }
//
//     final lid = prefs.getString('lid') ?? '';
//     final token = "ABCD1";
//     final imei = await getImeiNumber() ?? '';
//     final deviceID = await getDeviceId()?.toString() ?? '';  // Ensure deviceID is a string
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
//             // Ensure that `bioToken` is a string
//             if (data['isSuccess']) {
//               final bioToken = data['bioToken']?.toString() ?? '';  // Explicitly cast or handle null
//
//               if (bioToken.isNotEmpty) {
//                 final userId = prefs.getString('validUserId') ?? '';
//
//                 if (userId.isNotEmpty) {
//                   await prefs.setString('userid', userId);
//                   await prefs.setString('deviceid', deviceID);  // Ensure this is a String
//                   await prefs.setString('biotoken', bioToken);
//                   await prefs.setBool('biometricEnabled', true);
//                   print("Biometric info saved successfully.");
//
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Biometric login has been enabled.')),
//                     );
//                   }
//                 } else {
//                   print("Error: validUserId is null.");
//                 }
//               } else {
//                 print('Error: bioToken is not a valid string.');
//                 if (context.mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Invalid biometric token received.')),
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
//               SnackBar(content: Text('Biometric setup was cancelled.')),
//             );
//           }
//         }
//       } catch (e) {
//         print("Error during biometric setup: $e");
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('An error occurred during biometric setup.')),
//           );
//         }
//       }
//     } else {
//       print("Error: lid is null or empty.");
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('User ID is missing. Cannot enable biometric.')),
//         );
//       }
//     }
//   }
// }
