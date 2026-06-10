import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muslim_community/services/azan_service.dart';

class MalePrayerSettingsController extends GetxController {
  var isAutoDetectLocation = true.obs;

  var fajrNotification = "Off".obs;
  var sunriseNotification = "Silent".obs;
  var dhuhrNotification = "Off".obs;
  var asrNotification = "Adhan".obs;
  var maghribNotification = "Adhan".obs;
  var ishaNotification = "Adhan".obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    fajrNotification.value = prefs.getString(AzanService.fajrKey) ?? "Off";
    dhuhrNotification.value = prefs.getString(AzanService.dhuhrKey) ?? "Off";
    asrNotification.value = prefs.getString(AzanService.asrKey) ?? "Adhan";
    maghribNotification.value = prefs.getString(AzanService.maghribKey) ?? "Adhan";
    ishaNotification.value = prefs.getString(AzanService.ishaKey) ?? "Adhan";
  }

  Future<void> _saveSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  void toggleAutoDetectLocation() {
    isAutoDetectLocation.value = !isAutoDetectLocation.value;
  }

  void toggleNotification(RxString notification, String key) {
    if (notification.value == "Off" || notification.value == "Silent") {
      notification.value = "Adhan";
    } else {
      notification.value = "Off";
    }
    _saveSetting(key, notification.value);
  }
}
