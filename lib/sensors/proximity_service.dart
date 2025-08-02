import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityService {
  static final ProximityService _instance = ProximityService._internal();
  factory ProximityService() => _instance;
  ProximityService._internal();

  final StreamController<bool> _proximityController = StreamController.broadcast();
  Stream<bool> get onProximity => _proximityController.stream;

  StreamSubscription<int>? _proxSub;

  void start() {
    _proxSub = ProximitySensor.events.listen((int event) {
      bool isNear = event > 0;
      _proximityController.add(isNear);
    });
  }

  void stop() {
    _proxSub?.cancel();
    _proxSub = null;
  }

  void dispose() {
    stop();
    _proximityController.close();
  }
}
