import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/model/brother_model.dart';

enum MaleDiscoverTab { nearMe, newReverts, verifiedOnly }

class MaleDiscoverController extends GetxController {
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
      case MaleDiscoverTab.verifiedOnly:
        return brothers.where((b) => b.isVerified).toList();
    }
  }

  void changeTab(MaleDiscoverTab tab) {
    selectedTab.value = tab;
  }
}
