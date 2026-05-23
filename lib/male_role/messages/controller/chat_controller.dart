import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/shared/model/chat_message_model.dart';
import 'package:muslim_community/male_role/messages/service/chat_service.dart';
import 'package:muslim_community/male_role/home/controller/userdatacontroller.dart';
import 'package:muslim_community/services/socket_service.dart';

class MaleChatController extends GetxController {
  final MaleChatService _chatService = MaleChatService();
  final MaleUserDataController _userDataController = Get.find<MaleUserDataController>();
  final SocketService _socketService = SocketService();
  
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  var messages = <ChatMessageModel>[].obs;
  var isLoading = false.obs;
  var isOtherUserOnline = false.obs;
  String? currentChatId;

  // Pagination fields
  var hasNextPage = false.obs;
  String? nextCursor;
  var isMoreLoading = false.obs;

  @override
  void onInit() {
    print('LIFECYCLE_DEBUG: Chat screen opened');
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // In reverse mode, scrollController.position.maxScrollExtent is the TOP of the chat (oldest messages)
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 &&
        !isMoreLoading.value &&
        hasNextPage.value) {
      if (currentChatId != null) {
        print("CHAT_PAGINATION: Loading more messages...");
        loadMoreMessages(currentChatId!);
      }
    }
  }

  void _cleanupSocketListeners() {
    _socketService.off('MESSAGE_SENT');
    _socketService.off('MESSAGE_DELIVERED');
    _socketService.off('MESSAGES_READ');
    _socketService.off('USER_ONLINE');
    _socketService.off('USER_OFFLINE');
  }

  Future<void> setupSocket(String chatId) async {
    // 1. Singleton Check: If already set up for this chat, don't repeat
    if (currentChatId == chatId && _socketService.isConnected) return;
    
    currentChatId = chatId;
    
    // 2. Clear previous listeners before adding new ones (Prevents Duplication)
    _cleanupSocketListeners();
    
    // 3. Connect (Singleton will handle if already connecting/connected)
    try {
      await _socketService.connect();
    } catch (e) {
      print("Socket connection error: $e");
    }
    
    // 4. Join Room
    _socketService.emit('JOIN_CHAT', {'chatId': chatId});
    print('SOCKET_DEBUG: JOIN_CHAT emitted for chatId: $chatId');

    // 5. Listen for new messages (MESSAGE_SENT)
    _socketService.on('MESSAGE_SENT', (data) {
      if (data != null) {
        print('SOCKET_DEBUG: Message received from socket: ${data['text'] ?? '...'}');
        final currentUserId = _userDataController.userId.value;
        final newMessage = ChatMessageModel.fromJson(data, currentUserId);
        
        // --- STRICT DEDUPLICATION ---
        // 1. Check by ID (Server assigned)
        // 2. Check by Text + isMe (Matching optimistic temp messages)
        final existingIndex = messages.indexWhere((m) => 
          m.id == newMessage.id || 
          (m.id.startsWith('temp_') && m.text == newMessage.text && m.isMe)
        );

        if (existingIndex != -1) {
          // Replace optimistic/existing message with server version
          messages[existingIndex] = newMessage;
          messages.refresh();
        } else {
          // Verify it's for the current chat before adding (Global Socket safety)
          final msgChatId = (data['chatId'] ?? data['chatid'] ?? '').toString();
          if (msgChatId.isEmpty || msgChatId == currentChatId) {
            // With reverse: true, we insert at 0 (bottom of screen)
            messages.insert(0, newMessage);
            scrollToBottom();
          }
        }

        // ACK Flow
        if (!newMessage.isMe) {
          _socketService.emit('DELIVERED_ACK', {'messageId': newMessage.id, 'chatId': chatId});
          _socketService.emit('READ_ACK', {'messageId': newMessage.id, 'chatId': chatId});
          _chatService.markChatAsRead(chatId);
        }
      }
    });

    // Listen for Message Delivered
    _socketService.on('MESSAGE_DELIVERED', (data) {
      if (data != null && data['chatId'] == chatId) {
        final String messageId = data['messageId'].toString();
        final index = messages.indexWhere((m) => m.id == messageId);
        if (index != -1) {
          messages[index].status = MessageStatus.delivered;
          messages.refresh();
        }
      }
    });

    // Listen for Messages Read
    _socketService.on('MESSAGES_READ', (data) {
      if (data != null && data['chatId'] == chatId) {
        final List<dynamic> updatedIds = data['updatedIds'] ?? [];
        for (var id in updatedIds) {
          final index = messages.indexWhere((m) => m.id == id.toString());
          if (index != -1) {
            messages[index].status = MessageStatus.read;
          }
        }
        messages.refresh();
      }
    });

    // Listen for User Presence
    _socketService.on('USER_ONLINE', (data) {
      print("USER_ONLINE received: $data");
      isOtherUserOnline.value = true;
    });

    _socketService.on('USER_OFFLINE', (data) {
      print("USER_OFFLINE received: $data");
      isOtherUserOnline.value = false;
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        // With reverse: true, the bottom is position 0
        scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> fetchMessages(String chatId) async {
    try {
      isLoading.value = true;
      // Don't clear here, use assignAll later
      await setupSocket(chatId);
      
      final currentUserId = _userDataController.userId.value;
      final response = await _chatService.getChatMessages(chatId);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        print('CHAT_DEBUG: API messages fetched: ${data.length}');
        
        // Handle pagination metadata
        if (responseData['meta'] != null) {
          hasNextPage.value = responseData['meta']['hasNextPage'] ?? false;
          nextCursor = responseData['meta']['nextCursor'];
        }

        // 1. API Response Analysis:
        // Based on your provided JSON, the API returns [Oldest -> Newest].
        // Example: First message is 01:16 AM, Last message is 18:13 PM.
        // In our UI, we use 'reverse: true' which means index 0 is the BOTTOM.
        // Therefore, we MUST reverse the API list so that the Newest message (18:13 PM) is at index 0.
        
        final List<ChatMessageModel> parsedMessages = data.map((json) {
          return ChatMessageModel.fromJson(json, currentUserId);
        }).toList();

        // Reverse to get [Newest (index 0) -> Oldest (index n)]
        final List<ChatMessageModel> chronologicalMessages = parsedMessages.reversed.toList();
        
        messages.assignAll(chronologicalMessages);
        print('CHAT_DEBUG: Final merged message list length: ${messages.length}');
        scrollToBottom();
        
        _chatService.markChatAsRead(chatId);
      }
    } catch (e) {
      print("Error fetching messages: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreMessages(String chatId) async {
    if (isMoreLoading.value || !hasNextPage.value || nextCursor == null) return;

    try {
      isMoreLoading.value = true;
      final response = await _chatService.getChatMessages(chatId, cursor: nextCursor);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        
        if (responseData['meta'] != null) {
          hasNextPage.value = responseData['meta']['hasNextPage'] ?? false;
          nextCursor = responseData['meta']['nextCursor'];
        }

        final currentUserId = _userDataController.userId.value;
        final newOlderMessages = data.map((json) => ChatMessageModel.fromJson(json, currentUserId)).toList().reversed.toList();
        
        // Add to the end of the list (top of screen in reverse mode)
        messages.addAll(newOlderMessages);
      }
    } catch (e) {
      print("Error loading more messages: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }

  Future<void> sendMessage(String chatId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    try {
      // Optimistic Update
      final currentUserId = _userDataController.userId.value;
      final currentUserName = _userDataController.userName.value;
      final tempMessage = ChatMessageModel.optimistic(
        text: text,
        myId: currentUserId,
        myName: currentUserName,
      );
      
      // With reverse: true, we insert at 0 (bottom)
      messages.insert(0, tempMessage);
      scrollToBottom();
      messageController.clear();
      
      final response = await _chatService.sendMessage(chatId, text);
      
      print("CONTROLLER_DEBUG: Send response status: ${response.statusCode}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final serverMessage = ChatMessageModel.fromJson(responseData['data'], currentUserId);
          
          // Replace the optimistic message with the real one from server
          final index = messages.indexWhere((m) => m.id == tempMessage.id);
          if (index != -1) {
            messages[index] = serverMessage;
          }
        } else {
          // Server returned success: false
          messages.removeWhere((m) => m.id == tempMessage.id);
          String errorMsg = responseData['message'] ?? "Failed to send message";
          Get.snackbar("Error", errorMsg);
          print("CONTROLLER_DEBUG: Server error: $errorMsg");
        }
      } else {
        // HTTP Error
        messages.removeWhere((m) => m.id == tempMessage.id);
        Get.snackbar("Error", "Failed to send message (${response.statusCode})");
        print("CONTROLLER_DEBUG: HTTP error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("Error sending message: $e");
      Get.snackbar("Error", "An error occurred");
    }
  }

  @override
  void onClose() {
    print('LIFECYCLE_DEBUG: Chat screen closed');
    if (currentChatId != null) {
      _socketService.emit('LEAVE_CHAT', {'chatId': currentChatId});
      _cleanupSocketListeners();
    }
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}