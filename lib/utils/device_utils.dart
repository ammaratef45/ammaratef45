import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';

class DeviceUtils {
  static const List<String> ADMIN_IDS = ['2a5f7709a7f90cf8'];
  static Future<bool> isAdmin() async {
    if (kIsWeb) return false;
    String id = await _getId();
    print(id);
    return ADMIN_IDS.contains(id);
  }

  static Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
