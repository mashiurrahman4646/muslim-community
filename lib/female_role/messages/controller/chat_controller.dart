import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/messages/model/chat_message_model.dart';
import 'package:muslim_community/female_role/messages/service/chat_service.dart';
import 'package:muslim_community/female_role/home/controller/userdatacontroller.dart';

class FemaleChatController extends GetxController {
  final FemaleChatService _chatService = FemaleChatService();
  final FemaleUserDataController _userDataController = Get.find<FemaleUserDataController>();
  
  final TextEditingController messageController = TextEditingController();
  var messages = <ChatMessageModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchMessages(String chatId) async {
    try {
      isLoading.value = true;
      final response = await _chatService.getChatMessages(chatId);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        
        final currentUserId = _userDataController.userId.value;
        messages.value = data.map((json) => ChatMessageModel.fromJson(json, currentUserId)).toList();
      }
    } catch (e) {
      print("Error fetching messages: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String chatId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    try {
      // Optimistic update
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final tempMsg = ChatMessageModel(
        id: tempId,
        text: text,
        time: "Sending...",
        isMe: true,
      );
      messages.add(tempMsg);
      messageController.clear();

      final response = await _chatService.sendMessage(chatId, text);
      
      if (response.statusCode == 201) {
        // Refresh messages to get the real one from server
        fetchMessages(chatId);
      } else {
        // Handle error - maybe remove the optimistic message
        Get.snackbar("Error", "Failed to send message");
      }
    } catch (e) {
      print("Error sending message: $e");
      Get.snackbar("Error", "An error occurred");
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
