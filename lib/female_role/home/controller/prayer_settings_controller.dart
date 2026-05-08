import 'package:get/get.dart';

class FemalePrayerSettingsController extends GetxController {
  var isAutoDetectLocation = true.obs;

  var fajrNotification = "Off".obs;
  var sunriseNotification = "Silent".obs;
  var dhuhrNotification = "Off".obs;
  var asrNotification = "Adhan".obs;
  var maghribNotification = "Adhan".obs;
  var ishaNotification = "Adhan".obs;

  void toggleAutoDetectLocation() {
    isAutoDetectLocation.value = !isAutoDetectLocation.value;
  }

  void toggleNotification(RxString notification) {
    // ekbar click korle on (Adhan), ekbar click korle off (Off)
    if (notification.value == "Off" || notification.value == "Silent") {
      notification.value = "Adhan"; // Turn ON
    } else {
      notification.value = "Off"; // Turn OFF
    }
  }
}
