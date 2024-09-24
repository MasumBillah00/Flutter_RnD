import 'package:device_info_plus/device_info_plus.dart';

Future<String?> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try{
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id ??"unknown Device ID";

  }catch(e){

  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo.id;  // This returns a unique device ID (can be used in place of IMEI)
}

// Future<String?> getImeiNumber() async {
//   // Attempt to get phone permission first
//   if (await Permission.phone.isGranted) {
//     try {
//       return await getDeviceId();
//     } catch (e) {
//       print('Failed to get device ID: $e');
//       return null;
//     }
//   } else {
//     PermissionStatus status = await Permission.phone.request();
//     if (status.isGranted) {
//       return await getImeiNumber();
//     } else {
//       print('Phone permission denied');
//       return null;
//     }
//   }
// }
