import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/model/brother_model.dart';

class MaleSentRequestController extends GetxController {
  var isLoading = false.obs;
  var sentRequests = <BrotherModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSentRequests();
  }

  Future<void> fetchSentRequests() async {
    isLoading.value = true;
    // Using mock data for now as requested
    await Future.delayed(const Duration(milliseconds: 500));
    sentRequests.value = [
      BrotherModel(
        id: 'mock_1',
        connectionId: 'conn_1',
        name: 'Ahmed Hassan',
        age: 28,
        joinedAgo: '2 days ago',
        distance: 1.8,
        status: 'Requested',
        imageUrl: '',
        about: 'Mock sent request for design preview.',
        interests: ['Tech', 'Hiking'],
      ),
    ];
    isLoading.value = false;
  }

  void cancelRequest(String connectionId, String brotherId) {
    sentRequests.removeWhere((b) => b.id == brotherId);
    Get.snackbar("Design Only", "Cancel action triggered for UI");
  }
}
