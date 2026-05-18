import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/model/brother_model.dart';
import 'package:muslim_community/male_role/discover/controller/brothergetcontroller.dart';

enum MaleDiscoverTab { nearMe, newReverts }

class MaleDiscoverController extends GetxController {
  final BrotherGetController _brotherGetController = Get.put(BrotherGetController());

  var mainCategories = [
    'Brothers',
    'Learning',
    'Mosques',
    'Jumma',
    'Ask Brother',
  ].obs;
  var selectedCategory = 'Brothers'.obs;
  var selectedTab = MaleDiscoverTab.nearMe.obs;

  @override
  void onInit() {
    super.onInit();
    _brotherGetController.fetchBrothers(isRefresh: true);
  }

  List<BrotherModel> get filteredBrothers => _brotherGetController.brothers;

  void changeTab(MaleDiscoverTab tab) {
    selectedTab.value = tab;
    if (tab == MaleDiscoverTab.nearMe) {
      _brotherGetController.changeFilter('nearby-me');
    } else {
      _brotherGetController.changeFilter('new-reverts');
    }
  }

  void search(String query) {
    _brotherGetController.searchBrothers(query);
  }

  void loadMore() {
    _brotherGetController.fetchBrothers(isRefresh: false);
  }
}
