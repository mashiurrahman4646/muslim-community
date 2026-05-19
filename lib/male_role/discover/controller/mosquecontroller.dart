import 'dart:convert';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/model/mosque_model.dart';
import 'package:muslim_community/male_role/discover/service/mosqueservice.dart';

class MosqueController extends GetxController {
  final MosqueService _service = MosqueService();
  var mosques = <MosqueModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchNearbyMosques({double latitude = 23.7298, double longitude = 90.4125}) async {
    isLoading.value = true;
    try {
      final response = await _service.getNearbyMosques(latitude: latitude, longitude: longitude);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        mosques.assignAll(data.map((item) => MosqueModel.fromJson(item)).toList());
      } else {
        print("Failed to load mosques: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching mosques: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchNearbyMosques();
  }
}
