import 'package:muslim_community/male_role/home/controller/qibla_controller.dart';
import 'package:muslim_community/male_role/home/controller/payertimecontroller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MaleHomeController extends GetxController {
  final MaleQiblaController qiblaController = Get.put(MaleQiblaController());
  final PrayerTimeController prayerTimeController = Get.put(PrayerTimeController());

  var isLoading = true.obs;
  var currentLocation = "Unknown".obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);

      // Check and request location permission if needed
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("Location permission denied.");
        isLoading(false);
        return;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location services are disabled.");
        isLoading(false);
        return;
      }

      Position? position;
      try {
        // Use low accuracy and a timeout to ensure it resolves quickly (even indoors)
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 5),
        );
      } catch (e) {
        print("getCurrentPosition failed: $e. Trying getLastKnownPosition...");
        position = await Geolocator.getLastKnownPosition();
      }

      if (position != null) {
        // Fetch prayer times using the new controller
        await prayerTimeController.fetchPrayerTimes(position.latitude, position.longitude);

        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            String city = place.locality ?? place.subAdministrativeArea ?? place.name ?? "";
            String country = place.country ?? "";
            if (city.isNotEmpty && country.isNotEmpty) {
              currentLocation.value = "$city, $country";
            } else if (city.isNotEmpty) {
              currentLocation.value = city;
            } else if (country.isNotEmpty) {
              currentLocation.value = country;
            }
          }
        } catch (geocodingError) {
          print("Geocoding failed: $geocodingError");
          currentLocation.value = "GPS Location";
        }
      } else {
        print("Both getCurrentPosition and getLastKnownPosition returned null.");
      }

      isLoading(false);
    } catch (e) {
      print("Error fetching location: $e");
      isLoading(false);
    }
  }
}
