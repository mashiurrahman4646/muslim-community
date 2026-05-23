import 'dart:convert';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/service/maleprofiledetailsservice.dart';
import 'package:muslim_community/male_role/discover/model/brother_model.dart';
import 'package:muslim_community/app_config.dart';

class MaleProfileDetailsController extends GetxController {
  final MaleProfileDetailsService _service = MaleProfileDetailsService();
  
  var isLoading = false.obs;
  var brother = Rxn<BrotherModel>();

  Future<void> fetchProfile(String userId) async {
    try {
      isLoading.value = true;
      final response = await _service.fetchPublicProfile(userId);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> data = responseData['data'] ?? {};
        
        String uImage = data['profileImage'] ?? '';
        if (uImage.isNotEmpty && !uImage.startsWith('http')) {
          final serverRoot = AppConfig.baseUrl.replaceAll('/api/v1', '');
          uImage = uImage.startsWith('/') ? "$serverRoot$uImage" : "$serverRoot/$uImage";
        }

        brother.value = BrotherModel(
          id: data['_id'] ?? data['id'] ?? userId,
          name: data['name'] ?? 'Unknown',
          age: data['age'] ?? 0,
          joinedAgo: '', // You might want to format createdAt here
          distance: 0.0,
          status: 'Connect', // Default or handle based on connection object
          imageUrl: uImage,
          about: data['about'] ?? 'No information provided yet.',
          revertHistory: data['revertHistory'] ?? 'No revert history provided yet.',
          interests: List<String>.from(data['interests'] ?? []),
        );
      }
    } catch (e) {
      print("Error fetching male profile details: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
