import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/service/requestcancelservice.dart';
import 'package:muslim_community/male_role/discover/controller/brothergetcontroller.dart';
import 'dart:convert';

class MaleRequestCancelController extends GetxController {
  final MaleRequestCancelService _service = MaleRequestCancelService();

  Future<void> cancelRequest(String userId, String connectionId) async {
    print("=== CANCEL REQUEST TRIGGERED ===");
    print("  userId      : $userId");
    print("  connectionId: $connectionId");

    try {
      final response = await _service.cancelConnectionRequest(connectionId);

      print("  Status Code : ${response.statusCode}");
      print("  Response    : ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("  ✅ Cancel SUCCESS — Reverting status to Connect");
        if (Get.isRegistered<BrotherGetController>()) {
          Get.find<BrotherGetController>().updateStatus(userId, 'Connect');
        }
      } else if (response.statusCode == 403) {
        // 403 means current user is NOT the sender — the other person sent the request TO us
        print("  ℹ️ Not the sender — marking as Received request");
        if (Get.isRegistered<BrotherGetController>()) {
          Get.find<BrotherGetController>().updateStatus(userId, 'Received');
        }
      } else {
        final error = jsonDecode(response.body);
        print("  ❌ Cancel FAILED: ${error['message']}");
        Get.snackbar("Error", error['message'] ?? "Failed to cancel request.");
      }
    } catch (e) {
      print("  💥 EXCEPTION: $e");
      Get.snackbar("Error", "Something went wrong.");
    }
  }
}
