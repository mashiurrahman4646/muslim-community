import 'package:get/get.dart';
import 'package:muslim_community/female_role/messages/model/chat_message_model.dart';

class FemaleChatController extends GetxController {
  var messages = <ChatMessageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  void loadMessages() {
    // Mock data based on the screenshot
    messages.value = [
      ChatMessageModel(
        id: '1',
        text: 'Salam alaikum sister!',
        time: '10:30 AM',
        isMe: false,
      ),
      ChatMessageModel(
        id: '2',
        text: 'Wa alaikum salam Aisha! How are you?',
        time: '10:35 AM',
        isMe: true,
      ),
      ChatMessageModel(
        id: '3',
        text: 'Alhamdulillah, doing well.',
        time: '10:38 AM',
        isMe: false,
      ),
      ChatMessageModel(
        id: '4',
        text: 'InshaAllah see you at the halaqa tomorrow sister',
        time: '10:42 AM',
        isMe: false,
      ),
    ];
  }
}
