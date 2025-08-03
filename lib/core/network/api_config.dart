/// lib/core/network/api_config.dart

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class ApiConfig {
  static String? _baseUrl;

  /// 1️⃣ Your PC’s on-LAN address:
  static const _physicalDeviceBase = 'http://192.168.1.74:5000/api';

  /// 2️⃣ Android emulator:
  static const _androidEmulatorBase = 'http://10.0.2.2:5000/api';

  /// 3️⃣ iOS simulator:
  static const _iosSimulatorBase   = 'http://localhost:5000/api';

  /// Call this once per run; it caches.
  static Future<String> get baseUrl async {
    if (_baseUrl != null) return _baseUrl!;

    final info = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      _baseUrl = android.isPhysicalDevice
          ? _physicalDeviceBase
          : _androidEmulatorBase;
    }
    else if (Platform.isIOS) {
      final ios = await info.iosInfo;
      _baseUrl = ios.isPhysicalDevice
          ? _physicalDeviceBase
          : _iosSimulatorBase;
    }
    else {
      // web / desktop
      _baseUrl = _physicalDeviceBase;
    }

    return _baseUrl!;
  }
}
