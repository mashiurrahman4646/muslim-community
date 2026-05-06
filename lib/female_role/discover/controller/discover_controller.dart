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
        imageUrl: 'https://i.pravatar.cc/150?u=aisha',
      ),
      SisterModel(
        name: 'Fatima',
        age: 31,
        joinedAgo: '5 years ago',
        distance: 5.0,
        status: 'Connect',
        isVerified: false,
        isOnline: true,
        imageUrl: 'https://i.pravatar.cc/150?u=fatima',
      ),
      SisterModel(
        name: 'Khadija R.',
        age: 24,
        joinedAgo: '8 months ago',
        distance: 12.0,
        status: 'Requested',
        isVerified: true,
        isOnline: true,
        imageUrl: 'https://i.pravatar.cc/150?u=khadija',
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
        imageUrl: 'https://i.pravatar.cc/150?u=zainab',
      ),
      SisterModel(
        name: 'Maryam',
        age: 27,
        joinedAgo: '2 years ago',
        distance: 3.0,
        status: 'Connect',
        isVerified: false,
        isOnline: true,
        imageUrl: 'https://i.pravatar.cc/150?u=maryam',
      ),
      SisterModel(
        name: 'Ruqayya',
        age: 23,
        joinedAgo: '1 year ago',
        distance: 45.0,
        status: 'Connect',
        isVerified: true,
        isOnline: true,
        imageUrl: 'https://i.pravatar.cc/150?u=ruqayya',
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
