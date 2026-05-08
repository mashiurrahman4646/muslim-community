import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MalePersonalInfoController extends GetxController {
  var isEditingPersonalDetails = false.obs;
  var isEditingAboutMe = false.obs;
  var isEditingStory = false.obs;
  var isEditingInterests = false.obs;

  bool get isAnyEditing =>
      isEditingPersonalDetails.value ||
      isEditingAboutMe.value ||
      isEditingStory.value ||
      isEditingInterests.value;

  late TextEditingController nameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController locationCtrl;
  late TextEditingController durationCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController aboutCtrl;
  late TextEditingController storyCtrl;

  var interestsList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    nameCtrl = TextEditingController(text: "Omar Khan");
    ageCtrl = TextEditingController(text: "24");
    locationCtrl = TextEditingController(text: "London, UK");
    durationCtrl = TextEditingController(text: "8 months");
    emailCtrl = TextEditingController(text: "o***@email.com");
    aboutCtrl = TextEditingController(
        text:
            "Assalamu alaikum! I'm Omar, a recent revert navigating my beautiful new faith journey. I'm passionate about learning, connecting with other brothers, and finding peace in my daily prayers. Looking forward to growing together in this supportive community.");
    storyCtrl = TextEditingController(
        text:
            "My journey to Islam started during university when I began reading the Quran out of curiosity. The profound peace and logical clarity I found in its verses completely changed my perspective on life. Taking my Shahada was the most liberating moment of my life.");
    
    interestsList.assignAll(["Quran Learning", "Salah", "Community", "Islamic History"]);
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    locationCtrl.dispose();
    durationCtrl.dispose();
    emailCtrl.dispose();
    aboutCtrl.dispose();
    storyCtrl.dispose();
    super.onClose();
  }

  void saveAll() {
    isEditingPersonalDetails.value = false;
    isEditingAboutMe.value = false;
    isEditingStory.value = false;
    isEditingInterests.value = false;
  }

  void addInterest(String text) {
    if (text.isNotEmpty && interestsList.length < 10 && !interestsList.contains(text)) {
      interestsList.add(text);
    }
  }

  void removeInterest(String text) {
    interestsList.remove(text);
  }
}
