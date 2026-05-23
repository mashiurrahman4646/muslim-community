import 'dart:convert';
import 'package:get/get.dart';
import 'package:muslim_community/shared/model/khutbah_model.dart';
import 'package:muslim_community/male_role/discover/service/jummanowplayingservice.dart';

class JummaNowPlayingController extends GetxController {
  final JummaNowPlayingService _service = JummaNowPlayingService();
  var khutbah = Rxn<KhutbahModel>();
  var isLoading = false.obs;

  Future<void> fetchKhutbahDetails(String khutbahId) async {
    isLoading.value = true;
    try {
      final response = await _service.getKhutbahById(khutbahId: khutbahId);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final dynamic data = responseData['data'];
        if (data != null) {
          khutbah.value = KhutbahModel.fromJson(data);
        }
      } else {
        print("Failed to load khutbah details: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching khutbah details: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
