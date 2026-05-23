import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/jummarole/profile/service/jumma_profile_edit_service.dart';
import 'package:muslim_community/male_role/home/service/userdataservice.dart';

class JummaPersonalInfoController extends GetxController {
  final JummaProfileEditService _editService = JummaProfileEditService();
  final ImagePicker _picker = ImagePicker();

  var isEditingPersonalDetails = false.obs;
  var isLoading = false.obs;
  var isFetchingProfile = false.obs;
  
  Rx<File?> selectedProfileImage = Rx<File?>(null);
  var profileImageUrl = "".obs;

  bool get isAnyEditing => isEditingPersonalDetails.value;

  late TextEditingController nameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController durationCtrl;
  late TextEditingController emailCtrl;

  String? _revertDate;

  @override
  void onInit() {
    super.onInit();
    nameCtrl = TextEditingController(text: "");
    ageCtrl = TextEditingController(text: "");
    durationCtrl = TextEditingController(text: "");
    emailCtrl = TextEditingController(text: "");
    
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    isFetchingProfile.value = true;
    try {
      final service = MaleUserDataService(); // Generic enough to use
      final data = await service.fetchUserProfile();
      
      if (data != null) {
        nameCtrl.text = data['name'] ?? "";
        emailCtrl.text = data['email'] ?? "";
        
        // Date of birth to age
        if (data['dateOfBirth'] != null) {
          try {
            final dob = DateTime.parse(data['dateOfBirth']);
            final now = DateTime.now();
            int age = now.year - dob.year;
            if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
              age--;
            }
            ageCtrl.text = age.toString();
          } catch (e) {
            ageCtrl.text = "";
          }
        }

        final rawImg = data['profileImage'];
        if (rawImg != null && rawImg.isNotEmpty) {
          if (rawImg.startsWith('http')) {
            profileImageUrl.value = rawImg;
          } else {
            final baseDomain = AppConfig.baseUrl.replaceAll('/api/v1', '');
            profileImageUrl.value = "$baseDomain$rawImg";
          }
        }

        _revertDate = data['revertDate'];
        if (_revertDate != null && _revertDate!.isNotEmpty) {
          try {
            final date = DateTime.parse(_revertDate!);
            final now = DateTime.now();
            
            int years = now.year - date.year;
            int months = now.month - date.month;

            if (months < 0) {
              years -= 1;
              months += 12;
            }

            if (years > 0) {
              durationCtrl.text = "$years years${months > 0 ? ' $months months' : ''}";
            } else if (months > 0) {
              durationCtrl.text = "$months months";
            } else {
              durationCtrl.text = "New Imam";
            }
          } catch (e) {
            durationCtrl.text = _revertDate!;
          }
        } else {
          durationCtrl.text = "New Imam";
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      isFetchingProfile.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    durationCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedProfileImage.value = File(image.path);
    }
  }

  Future<void> saveAll() async {
    if (nameCtrl.text.trim().isEmpty) {
      Get.snackbar("Error", "Name cannot be empty",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await _editService.updateProfile(
        name: nameCtrl.text.trim(),
        profileImage: selectedProfileImage.value,
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Profile updated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
        isEditingPersonalDetails.value = false;
        await _loadProfileData(); // Reload to get updated data
      } else {
        Get.snackbar("Error", data['message'] ?? "Failed to update profile",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
