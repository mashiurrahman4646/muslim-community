import 'package:get/get.dart';
import 'package:muslim_community/male_role/notifications/service/male_connection_service.dart';
import 'package:muslim_community/male_role/discover/controller/brothergetcontroller.dart';

class MaleRequestAcceptController extends GetxController {
  final MaleConnectionService _service = MaleConnectionService();

  Future<void> acceptRequest(String userId, String connectionId) async {
    try {
      final response = await _service.updateConnectionStatus(connectionId, 'ACCEPT');

      if (response.statusCode == 200) {
        // Update local status in the main discovery list
        if (Get.isRegistered<BrotherGetController>()) {
          Get.find<BrotherGetController>().updateStatus(userId, 'Connected');
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
