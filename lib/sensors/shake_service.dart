import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeService {
  static final ShakeService _instance = ShakeService._internal();
  factory ShakeService() => _instance;
  ShakeService._internal();

  final StreamController<void> _shakeController = StreamController<void>.broadcast();
  Stream<void> get onShake => _shakeController.stream;

  StreamSubscription<AccelerometerEvent>? _accelSub;
  DateTime? _lastShake;

  /// Lowered to 1.2g so normal shakes register
  static const double shakeThreshold = 1.2;

  /// Minimum gap between shake events
  static const int debounceMs = 1000;

  Future<void> start() async {
    await stop();
    _accelSub = accelerometerEvents.listen(
      (event) {
        // convert m/s² to g
        final gX = event.x / 9.8;
        final gY = event.y / 9.8;
        final gZ = event.z / 9.8;
        final gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

        debugPrint('[ShakeService] x:${event.x.toStringAsFixed(1)} '
                   'y:${event.y.toStringAsFixed(1)} '
                   'z:${event.z.toStringAsFixed(1)} '
                   '→ gForce=${gForce.toStringAsFixed(3)}');

        if (gForce > shakeThreshold) {
          final now = DateTime.now();
          if (_lastShake == null ||
              now.difference(_lastShake!).inMilliseconds > debounceMs) {
            _lastShake = now;
            _shakeController.add(null);
          }
        }
      },
      onError: (e) => debugPrint('[ShakeService] error: $e'),
      cancelOnError: true,
    );
  }

  Future<void> stop() async {
    await _accelSub?.cancel();
    _accelSub = null;
  }

  Future<void> dispose() async {
    await stop();
    await _shakeController.close();
  }
}
