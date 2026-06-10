import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:muslim_community/male_role/home/controller/payertimecontroller.dart';
import 'package:muslim_community/female_role/home/controller/payertimecontroller.dart';

class AzanService extends GetxService {
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;
  
  // Settings keys
  static const String fajrKey = "fajr_azan";
  static const String dhuhrKey = "dhuhr_azan";
  static const String asrKey = "asr_azan";
  static const String maghribKey = "maghrib_azan";
  static const String ishaKey = "isha_azan";

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _player.dispose();
    super.onClose();
  }

  void _startTimer() {
    // Check every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkAndPlayAzan();
    });
  }

  Future<void> _checkAndPlayAzan() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final currentTimeStr = DateFormat("HH:mm").format(now);

    Map<String, String> timings = {};
    
    // Try to find male prayer controller
    if (Get.isRegistered<PrayerTimeController>()) {
      timings = Get.find<PrayerTimeController>().prayerTimings;
    } 
    // If not found or empty, try female prayer controller
    if (timings.isEmpty && Get.isRegistered<FemalePrayerTimeController>()) {
      timings = Get.find<FemalePrayerTimeController>().prayerTimings;
    }

    if (timings.isEmpty) return;

    // Mapping prayer names to their settings keys
    final prayerKeys = {
      'Fajr': fajrKey,
      'Dhuhr': dhuhrKey,
      'Asr': asrKey,
      'Maghrib': maghribKey,
      'Isha': ishaKey,
    };

    for (var entry in prayerKeys.entries) {
      String prayerName = entry.key;
      String settingsKey = entry.value;
      
      String? prayerTime = timings[prayerName];
      if (prayerTime != null && prayerTime.trim() == currentTimeStr) {
        // Check if Azan is enabled for this prayer
        bool isEnabled = prefs.getString(settingsKey) == "Adhan";
        
        if (isEnabled) {
          _playAzan(prayerName == 'Fajr');
          // Wait a minute to avoid playing multiple times for the same minute
          await Future.delayed(const Duration(minutes: 1));
          break; 
        }
      }
    }
  }

  Future<void> _playAzan(bool isFajr) async {
    try {
      String assetPath = isFajr 
          ? 'assets/audiofile/Fajaz Azan.mp3' 
          : 'assets/audiofile/azan1.mp3';
      
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e) {
      print("Error playing Azan: $e");
    }
  }

  // Helper method to manually play/stop for testing
  Future<void> stopAzan() async {
    await _player.stop();
  }
}
