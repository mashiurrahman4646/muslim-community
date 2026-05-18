import 'package:get/get.dart';
import 'package:muslim_community/female_role/notifications/service/female_connection_service.dart';
import 'package:muslim_community/female_role/discover/controller/sistergetcontroller.dart';

class FemaleRequestAcceptController extends GetxController {
  final FemaleConnectionService _service = FemaleConnectionService();

  Future<void> acceptRequest(String userId, String connectionId) async {
    try {
      final response = await _service.updateConnectionStatus(connectionId, 'ACCEPT');

      if (response.statusCode == 200) {
        // Update local status in the main discovery list
        if (Get.isRegistered<SisterGetController>()) {
          Get.find<SisterGetController>().updateStatus(userId, 'Connected');
        }
        Get.snackbar("Success", "Connection request accepted.");
      } else {
        Get.snackbar("Error", "Failed to accept request.");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong.");
    }
  }
}
