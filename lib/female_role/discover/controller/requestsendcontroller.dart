import 'package:get/get.dart';
import 'package:muslim_community/female_role/discover/service/requestsendservice.dart';
import 'package:muslim_community/female_role/discover/controller/sistergetcontroller.dart';
import 'dart:convert';

class FemaleRequestSendController extends GetxController {
  final FemaleRequestSendService _service = FemaleRequestSendService();

  Future<void> sendRequest(String userId) async {
    try {
      final response = await _service.sendConnectionRequest(userId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        print("Request sent successfully.");
        final body = jsonDecode(response.body);
        String? newConnectionId = body['data']?['_id'] ?? body['data']?['id'] ?? body['connectionId'];
        
        // Update local status in the main discovery list
        if (Get.isRegistered<SisterGetController>()) {
          Get.find<SisterGetController>().updateStatus(userId, 'Requested', connectionId: newConnectionId);
        }
      } else {
        final error = jsonDecode(response.body);
        print("Failed to send request: ${error['message']}");
        Get.snackbar("Error", error['message'] ?? "Failed to send request.");
      }
    } catch (e) {
      print("Error sending request: $e");
      Get.snackbar("Error", "Something went wrong.");
    }
  }
}
