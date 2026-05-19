import 'package:get/get.dart';
import 'package:muslim_community/female_role/discover/model/sister_model.dart';

class FemaleSentRequestController extends GetxController {
  var isLoading = false.obs;
  var sentRequests = <SisterModel>[].obs;

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
      SisterModel(
        id: 'mock_1',
        connectionId: 'conn_1',
        name: 'Sara Khan',
        age: 24,
        joinedAgo: '1 day ago',
        distance: 2.5,
        status: 'Requested',
        imageUrl: '',
        about: 'Mock sent request for design preview.',
        interests: ['Quran', 'Arabic'],
      ),
    ];
    isLoading.value = false;
  }

  void cancelRequest(String connectionId, String sisterId) {
    sentRequests.removeWhere((s) => s.id == sisterId);
    Get.snackbar("Design Only", "Cancel action triggered for UI");
  }
}
