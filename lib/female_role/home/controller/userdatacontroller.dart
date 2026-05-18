import 'package:get/get.dart';
import 'package:muslim_community/female_role/home/service/userdataservice.dart';
import 'package:muslim_community/app_config.dart';

class FemaleUserDataController extends GetxController {
  final FemaleUserDataService _service = FemaleUserDataService();

  var isLoading = false.obs;
  var userId = "".obs;
  var userName = "Aisha".obs;
  var userProfileImage = "".obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      isLoading(true);
      final data = await _service.fetchUserProfile();
      if (data != null) {
        userId.value = data['_id'] ?? data['id'] ?? "";
        userName.value = data['name'] ?? "Aisha";
        
        final rawImg = data['profileImage'];
        if (rawImg != null && rawImg.isNotEmpty && !rawImg.contains('.svg')) {
          if (rawImg.startsWith('http')) {
            userProfileImage.value = rawImg;
          } else {
            // Dynamic host replacement from baseUrl
            final baseDomain = AppConfig.baseUrl.replaceAll('/api/v1', '');
            userProfileImage.value = "$baseDomain$rawImg";
          }
        } else {
          userProfileImage.value = "";
        }
      }
    } catch (e) {
      print("Error in FemaleUserDataController: $e");
    } finally {
      isLoading(false);
    }
  }
}
