import 'dart:async';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class QiblaController extends GetxController {
  // =====================
  // OBSERVABLE VALUES
  // =====================
  var compassHeading = 0.0.obs;
  var qiblaDirection = 267.0.obs; // fallback (Dhaka approx)
  var dialRotation = 0.0.obs;
  var needleRotation = 0.0.obs;

  var needleOffset = 0.0.obs;

  var isSensorAvailable = true.obs;
  var isLoading = true.obs;
  var accuracyStatus = "".obs;

  // =====================
  // STREAM SUBSCRIPTIONS
  // =====================
  StreamSubscription? _compassSub;
  StreamSubscription? _positionSub;

  @override
  void onInit() {
    super.onInit();
    initCompass();
    startLocationUpdates();
  }

  @override
  void onClose() {
    _compassSub?.cancel();
    _positionSub?.cancel();
    super.onClose();
  }

  // =====================
  // COMPASS SENSOR
  // =====================
  void initCompass() {
    _compassSub = FlutterCompass.events?.listen((event) {
      if (event.heading == null) {
        isSensorAvailable.value = false;
        return;
      }

      double heading = event.heading!;

      // normalize 0 - 360
      if (heading < 0) heading += 360;

      compassHeading.value = heading;
      isSensorAvailable.value = true;

      _updateRotations();

      // Accuracy check (safe)
      final accuracy = event.accuracy;

      if (accuracy != null && accuracy > 15) {
        accuracyStatus.value =
        "Low Accuracy: Move phone in 8-shape to calibrate compass";
      } else {
        accuracyStatus.value = "";
      }
    });
  }

  // =====================
  // LOCATION HANDLING
  // =====================
  Future<void> startLocationUpdates() async {
    try {
      isLoading.value = true;

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        isLoading.value = false;
        return;
      }

      // initial position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _updateQiblaFromPosition(position);

      // stream updates
      _positionSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((position) {
        _updateQiblaFromPosition(position);
      });
    } catch (e) {
      print("Qibla error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _updateQiblaFromPosition(Position position) {
    qiblaDirection.value = calculateQiblaDirection(
      position.latitude,
      position.longitude,
    );

    _updateRotations();
  }

  // =====================
  // QIBLA CALCULATION
  // =====================
  double calculateQiblaDirection(double lat, double lng) {
    const meccaLat = 21.422487;
    const meccaLng = 39.826206;

    double phi1 = lat * (math.pi / 180);
    double phi2 = meccaLat * (math.pi / 180);
    double deltaLambda = (meccaLng - lng) * (math.pi / 180);

    double y = math.sin(deltaLambda) * math.cos(phi2);
    double x = math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);

    double bearing = math.atan2(y, x);

    double bearingDeg = (bearing * 180 / math.pi + 360) % 360;

    return bearingDeg;
  }

  // =====================
  // ROTATION UPDATE
  // =====================
  void _updateRotations() {
    // dialRotation keeps N pointing to true North
    dialRotation.value = -compassHeading.value / 360.0;
    
    // needleRotation points to Qibla relative to device heading
    // If heading == qiblaDirection, needle should be at 0 (UP)
    double relativeAngle = qiblaDirection.value - compassHeading.value;
    
    // Normalize to [0, 360]
    while (relativeAngle < 0) relativeAngle += 360;
    while (relativeAngle >= 360) relativeAngle -= 360;
    
    needleRotation.value = relativeAngle / 360.0;
  }
}