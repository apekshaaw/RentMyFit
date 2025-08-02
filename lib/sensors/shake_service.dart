import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeService {
  static final ShakeService _instance = ShakeService._internal();
  factory ShakeService() => _instance;
  ShakeService._internal();

  final StreamController<void> _shakeController = StreamController.broadcast();
  Stream<void> get onShake => _shakeController.stream;

  StreamSubscription? _accelSub;
  DateTime? _lastShake;
  static const double shakeThreshold = 15; // Adjust sensitivity

  void start() {
    _accelSub = accelerometerEvents.listen((event) {
      double gX = event.x / 9.8;
      double gY = event.y / 9.8;
      double gZ = event.z / 9.8;

      double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      if (gForce > 2.7) { // rough shake detection
        final now = DateTime.now();
        if (_lastShake == null || now.difference(_lastShake!) > const Duration(seconds: 1)) {
          _lastShake = now;
          _shakeController.add(null);
        }
      }
    });
  }

  void stop() {
    _accelSub?.cancel();
    _accelSub = null;
  }

  void dispose() {
    stop();
    _shakeController.close();
  }
}
