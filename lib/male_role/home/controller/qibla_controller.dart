import 'package:get/get.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
class MaleQiblaController extends GetxController {
  
  var compassHeading = 0.0.obs;
  var qiblaDirection = 267.0.obs; // Default to Dhaka Qibla direction as fallback
  var dialRotation = 0.0.obs;   // Angle for side.png (in turns)
  var needleRotation = 0.0.obs; // Angle for qiblacompas.png (in turns)
  
  // Offset if the needle image doesn't point UP (North) by default
  // 0.0 = UP, 0.25 = RIGHT, 0.5 = DOWN, 0.75 = LEFT
  var needleOffset = 0.0.obs; 

  var isSensorAvailable = true.obs;
  var isLoading = true.obs;
  var accuracyStatus = "".obs;

  @override
  void onInit() {
    super.onInit();
    initCompass();
    startLocationUpdates();
  }

  void initCompass() {
    FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading != null) {
        double heading = event.heading!;
        if (heading < 0) heading += 360;
        
        compassHeading.value = heading;
        isSensorAvailable.value = true;
        
        _updateRotations();

        if (event.accuracy != null) {
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

  Future<void> startLocationUpdates() async {
    try {
      isLoading(true);
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        print("Qibla: Location permission denied");
        isLoading(false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _updateQiblaFromPosition(position);
      
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        _updateQiblaFromPosition(position);
      });
      
    } catch (e) {
      print("Error in location updates: $e");
    } finally {
      isLoading(false);
    }
  }

  void _updateQiblaFromPosition(Position position) {
    double calculatedQibla = calculateQiblaDirection(
      position.latitude,
      position.longitude,
    );
    
    qiblaDirection.value = calculatedQibla;
    print("Qibla: Precise bearing: ${qiblaDirection.value.toStringAsFixed(2)} at ${position.latitude}, ${position.longitude}");
    _updateRotations();
  }

  double calculateQiblaDirection(double latitude, double longitude) {
    // Mecca coordinates (High Precision)
    const double meccaLat = 21.422487;
    const double meccaLng = 39.826206;
    
    double phi1 = latitude * (math.pi / 180.0);
    double lambda1 = longitude * (math.pi / 180.0);
    double phi2 = meccaLat * (math.pi / 180.0);
    double lambda2 = meccaLng * (math.pi / 180.0);
    
    double deltaLambda = lambda2 - lambda1;
    
    double y = math.sin(deltaLambda) * math.cos(phi2);
    double x = math.cos(phi1) * math.sin(phi2) - 
               math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);
    
    double qibla = math.atan2(y, x);
    double qiblaDegrees = qibla * (180.0 / math.pi);
    
    return (qiblaDegrees + 360.0) % 360.0;
  }
}
