import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/model/mosque_model.dart';
import 'package:muslim_community/male_role/discover/service/mosqueservice.dart';
import 'package:muslim_community/services/socket_service.dart';

class MosqueController extends GetxController {
  final MosqueService _service = MosqueService();
  final SocketService _socketService = SocketService();
  
  var mosques = <MosqueModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNearbyMosques();
    _setupSocketListeners();
  }

  @override
  void onClose() {
    _removeSocketListeners();
    super.onClose();
  }

  void _setupSocketListeners() async {
    try {
      if (!_socketService.isConnected) {
        await _socketService.connect();
      }
      _socketService.on('UPDATE_DISCOVERY', (data) {
        print("SOCKET_DEBUG: Discovery update received for mosques");
        fetchNearbyMosques(isSilent: true);
      });
      _socketService.on('NEW_MOSQUE', (data) {
        print("SOCKET_DEBUG: New mosque added");
        fetchNearbyMosques(isSilent: true);
      });
    } catch (e) {
      print("Error setting up socket listeners for mosques: $e");
    }
  }

  void _removeSocketListeners() {
    _socketService.off('UPDATE_DISCOVERY');
    _socketService.off('NEW_MOSQUE');
  }

  Future<void> fetchNearbyMosques({double latitude = 23.7298, double longitude = 90.4125, bool isSilent = false}) async {
    if (!isSilent) isLoading.value = true;
    try {
      final response = await _service.getNearbyMosques(latitude: latitude, longitude: longitude);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        final List<MosqueModel> newMosques = data.map((item) => MosqueModel.fromJson(item)).toList();
        
        if (mosques.length != newMosques.length) {
          mosques.assignAll(newMosques);
        } else {
          mosques.assignAll(newMosques);
        }
      } else {
        print("Failed to load mosques: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching mosques: $e");
    } finally {
      if (!isSilent) isLoading.value = false;
    }
  }

  /// Alias used by RefreshIndicator in the UI
  Future<void> fetchMosques() => fetchNearbyMosques();
}
