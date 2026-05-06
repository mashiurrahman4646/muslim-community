import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/group/model/group_model.dart';

class MaleGroupController extends GetxController {
  var groups = <GroupModel>[].obs;
  var filteredGroups = <GroupModel>[].obs;
  var categories = ['Groups', 'Learning', 'Mosques', 'Jumma', 'Ask Imam'].obs;
  var selectedCategory = 'Groups'.obs;

  @override
  void onInit() {
    super.onInit();
    loadGroups();
  }

  void loadGroups() {
    // Mock data using the same text content as Female but we'll use male colors in the UI
    groups.value = [
      GroupModel(
        id: '1',
        name: 'New Reverts in London',
        category: 'Local',
        memberCount: 124,
        description: 'A safe space for new reverts in the London area to connect and support each other.',
        isJoined: false,
        icon: Icons.location_on_outlined,
      ),
      GroupModel(
        id: '2',
        name: 'Quran Study Circle',
        category: 'Learning',
        memberCount: 45,
        description: 'Weekly beginner-friendly Quran reading and tafsir sessions.',
        isJoined: true,
        icon: Icons.menu_book_outlined,
      ),
      GroupModel(
        id: '3',
        name: 'Emotional Support',
        category: 'Support',
        memberCount: 312,
        description: 'A judgment-free zone to discuss the emotional journey of reverting.',
        isJoined: false,
        icon: Icons.favorite_border_outlined,
      ),
      GroupModel(
        id: '4',
        name: 'General Discussion',
        category: 'Community',
        memberCount: 890,
        description: 'Connect with the global SYA community.',
        isJoined: true,
        icon: Icons.people_outline,
      ),
    ];
    filterGroups(selectedCategory.value);
  }

  void filterGroups(String category) {
    selectedCategory.value = category;
    if (category == 'Groups') {
      filteredGroups.assignAll(groups); // For mockup, show all in Groups
    } else {
      filteredGroups.assignAll(
        groups.where((g) => g.category.toLowerCase().contains(category.toLowerCase()) || g.name.toLowerCase().contains(category.toLowerCase())).toList(),
      );
      if (filteredGroups.isEmpty) {
        filteredGroups.assignAll(groups);
      }
    }
  }

  void toggleJoin(String groupId) {
    final index = groups.indexWhere((g) => g.id == groupId);
    if (index != -1) {
      final oldGroup = groups[index];
      groups[index] = GroupModel(
        id: oldGroup.id,
        name: oldGroup.name,
        category: oldGroup.category,
        memberCount: oldGroup.isJoined ? oldGroup.memberCount - 1 : oldGroup.memberCount + 1,
        description: oldGroup.description,
        isJoined: !oldGroup.isJoined,
        icon: oldGroup.icon,
      );
      filterGroups(selectedCategory.value); // refresh list
    }
  }
}
