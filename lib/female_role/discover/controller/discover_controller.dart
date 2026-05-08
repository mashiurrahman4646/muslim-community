import 'package:get/get.dart';
import 'package:muslim_community/female_role/discover/model/sister_model.dart';

enum DiscoverTab { nearMe, newReverts, verifiedOnly }

class FemaleDiscoverController extends GetxController {
  var selectedTab = DiscoverTab.nearMe.obs;
  var sisters = <SisterModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSisters();
  }

  void loadSisters() {
    // Mock data based on screenshot
    sisters.value = [
      SisterModel(
        name: 'Aisha M.',
        age: 28,
        joinedAgo: '3 years ago',
        distance: 2.4,
        status: 'Connected',
        isVerified: true,
        isOnline: true,
        imageUrl: 'assets/image/female.png',
        about: 'Assalamu alaikum! I am a passionate software engineer currently working remotely. I love exploring nature, reading Islamic history, and trying out new halal recipes in my free time.',
        revertHistory: 'Alhamdulillah, I was born into a Muslim family. My journey has been about finding my own spiritual connection and strengthening my imaan over the years.',
        interests: ['Nature', 'Islamic History', 'Cooking', 'Coding'],
      ),
      SisterModel(
        name: 'Fatima',
        age: 31,
        joinedAgo: '5 years ago',
        distance: 5.0,
        status: 'Connect',
        isVerified: false,
        isOnline: true,
        imageUrl: 'assets/image/female.png',
        about: 'Hello! I am a teacher by profession and a lifelong learner. I enjoy organizing community events and helping out at the local masjid.',
        revertHistory: 'I embraced Islam 5 years ago after a long period of studying different faiths. Finding Islam was like finding peace I never knew existed.',
        interests: ['Teaching', 'Community Service', 'Reading'],
      ),
      SisterModel(
        name: 'Khadija R.',
        age: 24,
        joinedAgo: '8 months ago',
        distance: 12.0,
        status: 'Requested',
        isVerified: true,
        isOnline: true,
        imageUrl: 'assets/image/female.png',
        about: 'Hi everyone! I am currently studying graphic design. I love creating digital art inspired by Islamic geometric patterns.',
        revertHistory: 'Born Muslim, trying to learn more about my deen every day.',
        interests: ['Art', 'Design', 'Calligraphy', 'Travel'],
      ),
      SisterModel(
        name: 'Zainab T.',
        age: 29,
        joinedAgo: 'New Revert',
        distance: 1.2,
        status: 'Connect',
        isVerified: true,
        isOnline: true,
        isNewRevert: true,
        imageUrl: 'assets/image/female.png',
        about: 'New revert here! Seeking supportive sisters to help me learn the basics of prayer and Arabic. I enjoy gardening and baking.',
        revertHistory: 'I took my Shahada just a month ago! I am so excited to be part of this beautiful community and eager to learn.',
        interests: ['Gardening', 'Baking', 'Learning Arabic'],
      ),
      SisterModel(
        name: 'Maryam',
        age: 27,
        joinedAgo: '2 years ago',
        distance: 3.0,
        status: 'Connect',
        isVerified: false,
        isOnline: true,
        imageUrl: 'assets/image/female.png',
        about: 'Assalamu alaikum. I am a nurse working in pediatrics. I value deep conversations and spending time with my family.',
        revertHistory: 'Alhamdulillah, raised Muslim.',
        interests: ['Healthcare', 'Family Time', 'Reading'],
      ),
      SisterModel(
        name: 'Ruqayya',
        age: 23,
        joinedAgo: '1 year ago',
        distance: 45.0,
        status: 'Connect',
        isVerified: true,
        isOnline: true,
        imageUrl: 'assets/image/female.png',
        about: 'Recent college grad navigating the professional world. Looking for like-minded sisters to build a supportive network.',
        revertHistory: 'I found Islam during my sophomore year of college through a friend. It changed my life completely.',
        interests: ['Networking', 'Coffee', 'Podcasts'],
      ),
    ];
  }

  List<SisterModel> get filteredSisters {
    switch (selectedTab.value) {
      case DiscoverTab.nearMe:
        return sisters.toList();
      case DiscoverTab.newReverts:
        return sisters.where((s) => s.isNewRevert).toList();
      case DiscoverTab.verifiedOnly:
        return sisters.where((s) => s.isVerified).toList();
    }
  }

  void changeTab(DiscoverTab tab) {
    selectedTab.value = tab;
  }
}
