import 'package:get/get.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';

class MaleQiblaController extends GetxController {
  var compassHeading = 0.0.obs;
  var qiblaDirection = 0.0.obs;
  var isSensorAvailable = true.obs;
  var isLoading = true.obs;

  // Kaaba Coordinates
  final double kaabaLat = 21.4225;
  final double kaabaLong = 39.8262;

  @override
  void onInit() {
    super.onInit();
    initCompass();
    calculateQiblaFromGPS();
  }

  void initCompass() {
    FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading != null) {
        double heading = event.heading!;
        if (heading < 0) heading += 360;
        compassHeading.value = heading;
        isSensorAvailable.value = true;
      } else {
        isSensorAvailable.value = false;
      }
    });
  }

  Future<void> calculateQiblaFromGPS() async {
    try {
      isLoading(true);
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        isSensorAvailable.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      _updateBearing(position.latitude, position.longitude);
      
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        _updateBearing(position.latitude, position.longitude);
      });

    } catch (e) {
      print("Error calculating Qibla: $e");
      isSensorAvailable.value = false;
    } finally {
      isLoading(false);
    }
  }

  void _updateBearing(double lat, double lon) {
    double lat1 = lat * math.pi / 180;
    double lon1 = lon * math.pi / 180;
    double lat2 = kaabaLat * math.pi / 180;
    double lon2 = kaabaLong * math.pi / 180;

    double dLon = lon2 - lon1;

    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    double bearing = math.atan2(y, x);
    bearing = bearing * 180 / math.pi;
    bearing = (bearing + 360) % 360;

    qiblaDirection.value = bearing;
  }

  void updateQiblaDirection(double direction) {
    double normDir = direction;
    while (normDir < 0) normDir += 360;
    while (normDir >= 360) normDir -= 360;
    qiblaDirection.value = normDir;
  }

  double _normalize(double angle) {
    return (angle % 360 + 360) % 360;
  }

  double get dialAngle {
    return -_normalize(compassHeading.value) * (math.pi / 180);
  }

  double get needleAngle {
    double relativeAngle = qiblaDirection.value - compassHeading.value;
    return _normalize(relativeAngle) * (math.pi / 180);
  }
}
