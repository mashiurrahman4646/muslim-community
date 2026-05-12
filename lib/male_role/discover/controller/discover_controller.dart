import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/model/brother_model.dart';

enum MaleDiscoverTab { nearMe, newReverts }

class MaleDiscoverController extends GetxController {
  var mainCategories = ['Brothers', 'Learning', 'Mosques', 'Jumma', 'Ask Brother'].obs;
  var selectedCategory = 'Brothers'.obs;
  var selectedTab = MaleDiscoverTab.nearMe.obs;
  var brothers = <BrotherModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBrothers();
  }

  // All mock data lives here in the controller
  void loadBrothers() {
    brothers.value = [
      BrotherModel(
        name: 'Yusuf A.',
        age: 30,
        joinedAgo: '3 years ago',
        distance: 1.8,
        status: 'Connected',
        isVerified: true,
        isOnline: true,
        imageUrl: 'assets/image/male.png',
        about:
            'As-salamu alaykum. I am a civil engineer and I love spending time outdoors hiking and exploring. Active in the local masjid youth group.',
        revertHistory: 'Born Muslim, trying to learn more every day.',
        interests: ['Hiking', 'Engineering', 'Youth Mentorship'],
      ),
      BrotherModel(
        name: 'Omar H.',
        age: 27,
        joinedAgo: '5 years ago',
        distance: 4.2,
        status: 'Connect',
        isVerified: false,
        isOnline: true,
        imageUrl: 'assets/image/male.png',
        about:
            'Tech enthusiast and software developer. Always down for a game of soccer or discussing the latest in AI.',
        revertHistory:
            'Reverted 5 years ago during university. Alhamdulillah for the guidance.',
        interests: ['Soccer', 'Technology', 'AI', 'Reading'],
      ),
      BrotherModel(
        name: 'Ibrahim K.',
        age: 33,
        joinedAgo: '8 months ago',
        distance: 10.5,
        status: 'Requested',
        isVerified: true,
        isOnline: false,
        imageUrl: 'assets/image/male.png',
        about:
            'Doctor by profession. Passionate about health, fitness, and helping others. Looking to connect with brothers in the medical field.',
        revertHistory:
            'Born into a Muslim family. Searching for continuous spiritual growth.',
        interests: ['Medicine', 'Fitness', 'Volunteering'],
      ),
      BrotherModel(
        name: 'Bilal T.',
        age: 25,
        joinedAgo: 'New Revert',
        distance: 0.9,
        status: 'Connect',
        isVerified: true,
        isOnline: true,
        isNewRevert: true,
        imageUrl: 'assets/image/male.png',
        about:
            'New to Islam and eager to learn! Looking for brothers who can help me with learning how to pray and reading Quran.',
        revertHistory:
            'I took my Shahada last month! It has been an amazing journey of discovering peace.',
        interests: ['Learning Arabic', 'Quran', 'Coffee'],
      ),
      BrotherModel(
        name: 'Khalid M.',
        age: 29,
        joinedAgo: '2 years ago',
        distance: 6.0,
        status: 'Connect',
        isVerified: false,
        isOnline: true,
        imageUrl: 'assets/image/male.png',
        about:
            'Business owner and entrepreneur. I enjoy traveling, learning about different cultures, and trying new foods.',
        revertHistory:
            'Reverted 2 years ago. The local community has been incredibly supportive.',
        interests: ['Business', 'Travel', 'Food', 'Culture'],
      ),
      BrotherModel(
        name: 'Hamza R.',
        age: 22,
        joinedAgo: '1 year ago',
        distance: 30.0,
        status: 'Connect',
        isVerified: true,
        isOnline: false,
        imageUrl: 'assets/image/male.png',
        about:
            'Student currently finishing up my degree in history. Love reading classic literature and attending Islamic lectures.',
        revertHistory:
            'Born Muslim. Trying to deepen my knowledge of Islamic history.',
        interests: ['History', 'Literature', 'Lectures'],
      ),
    ];
  }

  // Filters brothers based on the active tab
  List<BrotherModel> get filteredBrothers {
    switch (selectedTab.value) {
      case MaleDiscoverTab.nearMe:
        return brothers.toList();
      case MaleDiscoverTab.newReverts:
        return brothers.where((b) => b.isNewRevert).toList();
    }
  }

  void changeTab(MaleDiscoverTab tab) {
    selectedTab.value = tab;
  }
}
