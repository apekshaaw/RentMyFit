import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityService {
  static final ProximityService _instance = ProximityService._internal();
  factory ProximityService() => _instance;
  ProximityService._internal();

  final StreamController<bool> _proximityController = StreamController<bool>.broadcast();
  Stream<bool> get onProximity => _proximityController.stream;

  StreamSubscription<int>? _proxSub;

  Future<void> start() async {
    ProximitySensor
      .setProximityScreenOff(true)
      .onError((error, stack) {
        debugPrint('[ProximityService] could not enable screenOff: $error');
      });

    await stop();

    _proxSub = ProximitySensor.events.listen(
      (int event) {
        final isNear = event > 0;
        debugPrint('[ProximityService] raw event=$event  isNear=$isNear');
        _proximityController.add(isNear);
      },
      onError: (error) {
        debugPrint('[ProximityService] sensor error: $error');
      },
      cancelOnError: true,
    );
  }

  Future<void> stop() async {
    await _proxSub?.cancel();
    _proxSub = null;
  }

  Future<void> dispose() async {
    await stop();
    await _proximityController.close();
  }
}
