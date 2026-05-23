import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:muslim_community/shared/model/khutbah_model.dart';
import 'package:muslim_community/male_role/discover/service/jummaservice.dart';
import 'package:muslim_community/services/socket_service.dart';

class JummaController extends GetxController {
  final JummaService _service = JummaService();
  final SocketService _socketService = SocketService();
  
  var khutbahs = <KhutbahModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKhutbahs();
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
        print("SOCKET_DEBUG: Discovery update received for jumma");
        fetchKhutbahs(isSilent: true);
      });
      _socketService.on('NEW_KHUTBAH', (data) {
        print("SOCKET_DEBUG: New khutbah added");
        fetchKhutbahs(isSilent: true);
      });
    } catch (e) {
      print("Error setting up socket listeners for jumma: $e");
    }
  }

  void _removeSocketListeners() {
    _socketService.off('UPDATE_DISCOVERY');
    _socketService.off('NEW_KHUTBAH');
  }

  Future<void> fetchKhutbahs({bool isSilent = false}) async {
    if (!isSilent) isLoading.value = true;
    try {
      final response = await _service.getKhutbahs();
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        final List<KhutbahModel> newKhutbahs = data.map((item) => KhutbahModel.fromJson(item)).toList();
        
        if (khutbahs.length != newKhutbahs.length) {
          khutbahs.assignAll(newKhutbahs);
        } else {
          khutbahs.assignAll(newKhutbahs);
        }
      } else {
        print("Failed to load khutbahs: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching khutbahs: $e");
    } finally {
      if (!isSilent) isLoading.value = false;
    }
  }
}
