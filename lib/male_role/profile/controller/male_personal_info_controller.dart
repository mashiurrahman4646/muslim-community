import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muslim_community/male_role/profile/service/male_profile_edit_service.dart';
import 'package:muslim_community/male_role/home/controller/userdatacontroller.dart';
import 'package:muslim_community/male_role/home/service/userdataservice.dart';
import 'package:muslim_community/app_config.dart';

class MalePersonalInfoController extends GetxController {
  final MaleProfileEditService _editService = MaleProfileEditService();
  final ImagePicker _picker = ImagePicker();

  var isEditingPersonalDetails = false.obs;
  var isEditingAboutMe = false.obs;
  var isEditingStory = false.obs;
  var isEditingInterests = false.obs;
  
  var isLoading = false.obs;
  Rx<File?> selectedProfileImage = Rx<File?>(null);
  var profileImageUrl = "".obs;
  var joinedAgo = "Joined some time ago".obs;

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
  var isFetchingProfile = false.obs;
  
  // To store original location data
  String? _currentCity;
  String? _currentCountry;
  String? _currentLat;
  String? _currentLng;
  String? _revertDate;

  @override
  void onInit() {
    super.onInit();
    nameCtrl = TextEditingController(text: "");
    ageCtrl = TextEditingController(text: "");
    locationCtrl = TextEditingController(text: "");
    durationCtrl = TextEditingController(text: "");
    emailCtrl = TextEditingController(text: "");
    aboutCtrl = TextEditingController(text: "");
    storyCtrl = TextEditingController(text: "");
    
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    isFetchingProfile.value = true;
    try {
      final service = MaleUserDataService();
      final data = await service.fetchUserProfile();
      
      if (data != null) {
        nameCtrl.text = data['name'] ?? "";
        aboutCtrl.text = data['aboutMe'] ?? "";
        storyCtrl.text = data['revertStory'] ?? "";
        emailCtrl.text = data['email'] ?? "";
        ageCtrl.text = (data['age'] ?? "").toString();

        final rawImg = data['profileImage'];
        if (rawImg != null && rawImg.isNotEmpty) {
          if (rawImg.startsWith('http')) {
            profileImageUrl.value = rawImg;
          } else {
            final baseDomain = AppConfig.baseUrl.replaceAll('/api/v1', '');
            profileImageUrl.value = "$baseDomain$rawImg";
          }
        }

        final createdAt = data['createdAt'];
        if (createdAt != null) {
          try {
            final date = DateTime.parse(createdAt);
            final now = DateTime.now();
            final difference = now.difference(date);
            final days = difference.inDays;

            if (days >= 365) {
              final years = (days / 365).floor();
              joinedAgo.value = "Joined $years years ago";
            } else if (days >= 30) {
              final months = (days / 30).floor();
              joinedAgo.value = "Joined $months months ago";
            } else if (days > 0) {
              joinedAgo.value = "Joined $days days ago";
            } else {
              joinedAgo.value = "Joined today";
            }
          } catch (e) {
            joinedAgo.value = "Joined recently";
          }
        }

        _revertDate = data['revertDate'];
        if (_revertDate != null && _revertDate!.isNotEmpty) {
          try {
            final date = DateTime.parse(_revertDate!);
            final now = DateTime.now();
            
            int years = now.year - date.year;
            int months = now.month - date.month;
            int days = now.day - date.day;

            if (days < 0) {
              months -= 1;
              // Simple adjustment for days in previous month
              days += 30; 
            }
            if (months < 0) {
              years -= 1;
              months += 12;
            }

            if (years > 0) {
              durationCtrl.text = "$years years${months > 0 ? ' $months months' : ''}";
            } else if (months > 0) {
              durationCtrl.text = "$months months";
            } else if (days > 0) {
              durationCtrl.text = "$days days";
            } else {
              durationCtrl.text = "New Revert";
            }
          } catch (e) {
            durationCtrl.text = _revertDate!;
          }
        } else {
          durationCtrl.text = "New Revert";
        }

        final loc = data['location'];
        if (loc != null) {
          _currentCity = loc['city'] ?? "";
          _currentCountry = loc['country'] ?? "";
          
          if (loc['coordinates'] != null && loc['coordinates'] is List) {
             _currentLng = loc['coordinates'][0]?.toString();
             _currentLat = loc['coordinates'][1]?.toString();
          }

          if (_currentCity!.isNotEmpty && _currentCountry!.isNotEmpty) {
            locationCtrl.text = "$_currentCity, $_currentCountry";
          } else {
            locationCtrl.text = "$_currentCity$_currentCountry";
          }
        }

        if (data['interests'] != null && data['interests'] is List) {
          interestsList.assignAll(List<String>.from(data['interests']));
        }
        
        // Handling image via MaleUserDataController global state in the UI
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
    locationCtrl.dispose();
    durationCtrl.dispose();
    emailCtrl.dispose();
    aboutCtrl.dispose();
    storyCtrl.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedProfileImage.value = File(image.path);
    }
  }

  Future<void> saveAll() async {
    isLoading.value = true;
    try {
      final response = await _editService.updateProfile(
        name: nameCtrl.text.trim(),
        aboutMe: aboutCtrl.text.trim(),
        revertStory: storyCtrl.text.trim(),
        revertDate: _revertDate, // Use original revertDate as it's locked
        interests: interestsList.toList(),
        profileImage: selectedProfileImage.value,
        city: _currentCity,
        country: _currentCountry,
        latitude: _currentLat ?? "0.0",
        longitude: _currentLng ?? "0.0",
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        isEditingPersonalDetails.value = false;
        isEditingAboutMe.value = false;
        isEditingStory.value = false;
        isEditingInterests.value = false;
        selectedProfileImage.value = null; // Clear selection after success

        // Refresh the global user data
        try {
          if (Get.isRegistered<MaleUserDataController>()) {
            await Get.find<MaleUserDataController>().getUserData();
          }
          // Also reload local data to refresh text controllers
          await _loadProfileData();
        } catch (e) {
          debugPrint("Could not refresh global user data: $e");
        }
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar('Error',
            'Failed to update profile: ${errorData['message'] ?? response.statusCode}',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Update Profile Error: $e");
      Get.snackbar('Error', 'An error occurred while updating',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
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
