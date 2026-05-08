import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JummaPersonalInfoController extends GetxController {
  var isEditingPersonalDetails = false.obs;
  bool get isAnyEditing =>
      isEditingPersonalDetails.value;

  late TextEditingController nameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController locationCtrl;
  late TextEditingController durationCtrl;
  late TextEditingController emailCtrl;


  @override
  void onInit() {
    super.onInit();
    nameCtrl = TextEditingController(text: "Yusuf Khan");
    ageCtrl = TextEditingController(text: "35");
    locationCtrl = TextEditingController(text: "London, UK");
    durationCtrl = TextEditingController(text: "10 years");
    emailCtrl = TextEditingController(text: "y***@email.com");

  }

  @override
  void onClose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    locationCtrl.dispose();
    durationCtrl.dispose();
    emailCtrl.dispose();

    super.onClose();
  }

  void saveAll() {
    isEditingPersonalDetails.value = false;
  }
}
