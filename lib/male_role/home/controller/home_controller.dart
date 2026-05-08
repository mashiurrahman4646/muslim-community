import 'package:muslim_community/male_role/home/controller/qibla_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MaleHomeController extends GetxController {
  final MaleQiblaController qiblaController = Get.put(MaleQiblaController());
  
  var isLoading = true.obs;
  var prayerTimings = <String, dynamic>{
    'timings': {
      'Fajr': '05:12',
      'Sunrise': '06:45',
      'Dhuhr': '12:30',
      'Asr': '15:45',
      'Maghrib': '18:15',
      'Isha': '19:45',
    }
  }.obs;
  var currentLocation = "Dhaka, Bangladesh".obs;
  var nextPrayer = "Maghrib".obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        currentLocation.value = "${place.locality ?? ''}, ${place.country ?? ''}";
      }
      
      isLoading(false);
    } catch (e) {
      print("Error fetching location: $e");
      isLoading(false);
    }
  }
}
