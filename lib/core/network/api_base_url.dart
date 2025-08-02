import 'dart:io';

const String emulatorBaseUrl = 'http://10.0.2.2:5000/api';
const String localNetworkBaseUrl = 'http://192.168.1.5:5000/api'; // ← change this to your PC's IP

String getBaseUrl() {
  if (Platform.isAndroid) {
    return emulatorBaseUrl; // works for Android emulator
  } else {
    return localNetworkBaseUrl; // works for iOS or physical devices
  }
}
