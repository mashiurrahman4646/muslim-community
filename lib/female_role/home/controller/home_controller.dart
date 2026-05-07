import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:muslim_community/services/prayer_service.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

import 'package:muslim_community/female_role/home/controller/qibla_controller.dart';

class HomeController extends GetxController {
  final PrayerService _prayerService = PrayerService();
  final QiblaController qiblaController = Get.put(QiblaController());
  
  var isLoading = true.obs;
  var prayerTimings = <String, dynamic>{}.obs;
  var currentLocation = "Loading...".obs;
  var nextPrayer = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      // 1. Get exact GPS position
      Position position = await _prayerService.getCurrentLocation();
      
      // 2. Identify City and Country from those coordinates
      Map<String, String> locationData = await _prayerService.getCityAndCountryFromLatLng(position);
      String city = locationData['city']!;
      String country = locationData['country']!;
      
      // 3. Update the UI header to show "City, Country"
      currentLocation.value = "$city, $country";
      
      // 4. Fetch prayer timings using the City-based API with Method 2
      final data = await _prayerService.getTimingsByCity(city, country);
      prayerTimings.value = data;
      
      if (data.containsKey('meta') && data['meta'].containsKey('qibla')) {
        double qibla = double.parse(data['meta']['qibla'].toString());
        qiblaController.updateQiblaDirection(qibla);
      }
      
      _calculateNextPrayer(data['timings']);
      
    } catch (e) {
      Get.snackbar("Error", "Could not fetch location or prayer times. Please ensure location is enabled.");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchDataByAddress(String address) async {
    try {
      isLoading(true);
      final data = await _prayerService.getTimingsByAddress(address);
      prayerTimings.value = data;
      currentLocation.value = address;
      _calculateNextPrayer(data['timings']);
    } catch (e) {
      Get.snackbar("Error", "Could not fetch prayer times for $address");
    } finally {
      isLoading(false);
    }
  }

  void _calculateNextPrayer(Map<String, dynamic> timings) {
    final now = DateTime.now();
    final format = DateFormat("HH:mm");
    
    List<String> prayerNames = ["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"];
    
    for (String prayer in prayerNames) {
      final timeStr = timings[prayer].split(" ")[0];
      final prayerTime = format.parse(timeStr);
      final fullPrayerTime = DateTime(now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
      
      if (fullPrayerTime.isAfter(now)) {
        nextPrayer.value = prayer;
        return;
      }
    }
    // If all prayers today have passed, the next is tomorrow's Fajr
    nextPrayer.value = "Fajr";
  }
}
