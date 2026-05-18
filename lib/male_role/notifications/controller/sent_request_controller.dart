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
    await Future.delayed(const Duration(seconds: 1));
    sentRequests.value = [
      BrotherModel(
        id: '3',
        connectionId: 'c3',
        name: 'Hamza Yusuf',
        age: 30,
        joinedAgo: '4 days ago',
        distance: 6.7,
        status: 'Requested',
        imageUrl: '',
        about: 'Working on community projects.',
        interests: ['Tech', 'Community'],
      ),
    ];
    isLoading.value = false;
  }

  void cancelRequest(String connectionId, String brotherId) {
    sentRequests.removeWhere((b) => b.id == brotherId);
    Get.snackbar("Design Only", "Cancel action triggered for UI");
  }
}
