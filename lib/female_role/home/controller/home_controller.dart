import 'package:muslim_community/female_role/home/controller/qibla_controller.dart';
import 'package:muslim_community/female_role/home/controller/payertimecontroller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final QiblaController qiblaController = Get.put(QiblaController());
  final FemalePrayerTimeController prayerTimeController = Get.put(FemalePrayerTimeController());

  var isLoading = true.obs;
  var currentLocation = "Dhaka, Bangladesh".obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      // Fetch prayer times using the new controller
      await prayerTimeController.fetchPrayerTimes(position.latitude, position.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        currentLocation.value =
            "${place.locality ?? ''}, ${place.country ?? ''}";
      }

      isLoading(false);
    } catch (e) {
      print("Error fetching location: $e");
      isLoading(false);
    }
  }
}
