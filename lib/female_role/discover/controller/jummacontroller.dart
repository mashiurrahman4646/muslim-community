import 'dart:convert';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/discover/model/khutbah_model.dart';
import 'package:muslim_community/female_role/discover/service/jummaservice.dart';

class JummaController extends GetxController {
  final JummaService _service = JummaService();
  var khutbahs = <KhutbahModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchKhutbahs() async {
    isLoading.value = true;
    try {
      final response = await _service.getKhutbahs();
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        khutbahs.assignAll(data.map((item) => KhutbahModel.fromJson(item)).toList());
      } else {
        print("Failed to load khutbahs: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching khutbahs: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchKhutbahs();
  }
}
