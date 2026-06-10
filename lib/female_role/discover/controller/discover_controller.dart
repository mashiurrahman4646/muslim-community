import 'package:get/get.dart';
import 'package:muslim_community/female_role/discover/model/sister_model.dart';
import 'package:muslim_community/female_role/discover/controller/sistergetcontroller.dart';

enum DiscoverTab { nearMe, newReverts }

class FemaleDiscoverController extends GetxController {
  final SisterGetController _sisterGetController = Get.put(SisterGetController());

  var mainCategories = [
    'Sisters',
    'Learning',
    'Mosques',
    'Jumma',
    'Ask Sister',
  ].obs;
  var selectedCategory = 'Sisters'.obs;
  var selectedTab = DiscoverTab.nearMe.obs;

  @override
  void onInit() {
    super.onInit();
    _sisterGetController.fetchSisters(isRefresh: true);
  }

  List<SisterModel> get filteredSisters => _sisterGetController.sisters;
  RxBool get isLoading => _sisterGetController.isLoading;

  void changeTab(DiscoverTab tab) {
    selectedTab.value = tab;
    if (tab == DiscoverTab.nearMe) {
      _sisterGetController.changeFilter('nearby-me');
    } else {
      _sisterGetController.changeFilter('new-reverts');
    }
  }

  void search(String query) {
    _sisterGetController.searchSisters(query);
  }

  void loadMore() {
    _sisterGetController.fetchSisters(isRefresh: false);
  }

  Future<void> fetchSisters() async {
    await _sisterGetController.fetchSisters(isRefresh: true);
  }
}
