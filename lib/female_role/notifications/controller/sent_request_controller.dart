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
    await Future.delayed(const Duration(seconds: 1));
    sentRequests.value = [
      SisterModel(
        id: '3',
        connectionId: 'c3',
        name: 'Sara Jamil',
        age: 26,
        joinedAgo: '1 week ago',
        distance: 5.2,
        status: 'Requested',
        imageUrl: '',
        about: 'Interested in community activities.',
        interests: ['Community'],
      ),
    ];
    isLoading.value = false;
  }

  void cancelRequest(String connectionId, String sisterId) {
    sentRequests.removeWhere((s) => s.id == sisterId);
    Get.snackbar("Design Only", "Cancel action triggered for UI");
  }
}
