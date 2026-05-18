import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/service/requestsendservice.dart';
import 'package:muslim_community/male_role/discover/controller/brothergetcontroller.dart';
import 'dart:convert';

class MaleRequestSendController extends GetxController {
  final MaleRequestSendService _service = MaleRequestSendService();

  Future<void> sendRequest(String userId) async {
    try {
      final response = await _service.sendConnectionRequest(userId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ SEND REQUEST SUCCESS");
        final body = jsonDecode(response.body);
        print("   Full response: $body");
        
        // Try all possible paths to get the new connection _id
        String? newConnectionId = body['data']?['_id']
            ?? body['data']?['id']
            ?? body['data']?['connection']?['_id']
            ?? body['_id']
            ?? body['connectionId'];
        
        print("   Extracted connectionId: $newConnectionId");
        
        // Update local status in the main discovery list
        if (Get.isRegistered<BrotherGetController>()) {
          Get.find<BrotherGetController>().updateStatus(userId, 'Requested', connectionId: newConnectionId);
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
