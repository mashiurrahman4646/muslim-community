import 'package:get/get.dart';
import 'package:muslim_community/female_role/messages/model/message_model.dart';

class FemaleMessagesController extends GetxController {
  var messages = <MessageModel>[].obs;
  var filteredMessages = <MessageModel>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  void loadMessages() {
    // Mock data based on the screenshot
    messages.value = [
      MessageModel(
        id: '1',
        name: 'Aisha M.',
        lastMessage: 'InshaAllah see you at the halaga',
        time: '10:42 AM',
        unreadCount: 2,
        isVerified: true,
        imageUrl: 'assets/image/female.png', 
      ),
      MessageModel(
        id: '2',
        name: 'New Reverts London',
        lastMessage: 'Maryam: Does anyone know a go',
        time: 'Yesterday',
        isGroup: true,
      ),
      MessageModel(
        id: '3',
        name: 'Khadija R.',
        lastMessage: 'Jazakallah khair for the book recon',
        time: 'Tuesday',
        isVerified: true,
      ),
      MessageModel(
        id: '4',
        name: 'Fatima',
        lastMessage: 'Salam, how was your first Ramad',
        time: 'Monday',
        isVerified: true,
      ),
    ];
    filteredMessages.assignAll(messages);
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
