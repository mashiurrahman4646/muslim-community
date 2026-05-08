import 'package:get/get.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
class QiblaController extends GetxController {
  
  var compassHeading = 0.0.obs;
  var qiblaDirection = 0.0.obs;
  var isSensorAvailable = true.obs;
  var isLoading = true.obs;
  var accuracyStatus = "".obs;

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
        
        // Handle accuracy status for calibration messages
        if (event.accuracy != null) {
           // On some devices accuracy might be low, need calibration (infinity pattern)
           if (event.accuracy! > 15) {
             accuracyStatus.value = "Low Accuracy: Please calibrate your compass (move in 8-figure)";
           } else {
             accuracyStatus.value = "";
           }
        }
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
      
      qiblaDirection.value = calculateQiblaDirection(
        position.latitude,
        position.longitude,
      );
      
    } catch (e) {
      print("Error calculating Qibla: $e");
    } finally {
      isLoading(false);
    }
  }

  double calculateQiblaDirection(double latitude, double longitude) {
    // Mecca coordinates
    double meccaLat = 21.422487 * (math.pi / 180.0);
    double meccaLng = 39.826206 * (math.pi / 180.0);
    
    double userLat = latitude * (math.pi / 180.0);
    double userLng = longitude * (math.pi / 180.0);
    
    double lngDiff = meccaLng - userLng;
    
    double y = math.sin(lngDiff);
    double x = math.cos(userLat) * math.tan(meccaLat) - math.sin(userLat) * math.cos(lngDiff);
    
    double qibla = math.atan2(y, x);
    qibla = qibla * (180.0 / math.pi); // Convert to degrees
    
    return (qibla + 360.0) % 360.0;
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
