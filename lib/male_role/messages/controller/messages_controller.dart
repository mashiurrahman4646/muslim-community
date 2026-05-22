import 'dart:convert';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/messages/model/message_model.dart';
import 'package:muslim_community/male_role/messages/service/chat_service.dart';
import 'package:muslim_community/male_role/home/controller/userdatacontroller.dart';

class MaleMessagesController extends GetxController {
  final MaleChatService _chatService = MaleChatService();
  final MaleUserDataController _userDataController = Get.isRegistered<MaleUserDataController>()
      ? Get.find<MaleUserDataController>()
      : Get.put(MaleUserDataController());

  var messages = <MessageModel>[].obs;
  var filteredMessages = <MessageModel>[].obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChatList();
  }

  Future<void> fetchChatList() async {
    try {
      isLoading.value = true;
      final response = await _chatService.getChatList();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        
        final currentUserId = _userDataController.userId.value;
        
        messages.value = data.map((json) => MessageModel.fromJson(json, currentUserId)).toList();
        filteredMessages.assignAll(messages);
      }
    } catch (e) {
      print("Error fetching chat list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void searchMessages(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredMessages.assignAll(messages);
    } else {
      filteredMessages.assignAll(
        messages.where((m) => m.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }
}
