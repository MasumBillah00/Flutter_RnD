import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String?> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo.id;  // This returns a unique device ID (can be used in place of IMEI)
}

Future<String?> getImeiNumber() async {
  // Attempt to get phone permission first
  if (await Permission.phone.isGranted) {
    try {
      // As IMEI access might not be allowed, fallback to device ID
      return await getDeviceId();
    } catch (e) {
      print('Failed to get device ID: $e');
      return null;
    }
  } else {
    // Request permission if it's not granted yet
    PermissionStatus status = await Permission.phone.request();
    if (status.isGranted) {
      return await getImeiNumber();
    } else {
      print('Phone permission denied');
      return null;
    }
  }
}
