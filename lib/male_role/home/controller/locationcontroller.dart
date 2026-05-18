import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/home/service/locationservice.dart';

class MaleLocationController extends GetxController {
  final MaleLocationService _service = MaleLocationService();
  var isLoading = false.obs;

  Future<void> updateUserLocation(String token) async {
    isLoading.value = true;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        print("Location permission denied. Skipping location patch.");
        return;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location services are disabled.");
        return;
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 5),
        );
      } catch (e) {
        print("getCurrentPosition failed, trying last known position: $e");
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        print("Could not retrieve any location. Skipping patch.");
        return;
      }

      String country = "Unknown";
      String city = "Unknown";
      
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        ).timeout(const Duration(seconds: 5));
        
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          country = place.country ?? "Unknown";
          city = place.locality ?? place.subAdministrativeArea ?? place.name ?? "Unknown";
        }
      } catch (e) {
        print("Reverse geocoding error: $e");
      }

      final response = await _service.patchLocation(
        accessToken: token,
        latitude: position.latitude,
        longitude: position.longitude,
        country: country,
        city: city,
      );

      print("Location Patch Response Status: ${response.statusCode}");
      print("Location Patch Response Body: ${response.body}");
    } catch (e) {
      print("Error patching location: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
