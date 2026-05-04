import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/jummarole/askimam/ui/askimamui.dart';
import 'package:muslim_community/jummarole/home/ui/jummahomeui.dart';
import 'package:muslim_community/jummarole/navbar/navbarcontroller.dart';
import 'package:muslim_community/jummarole/profile/ui/jummaprofileui.dart';

class JummaNavbarUI extends StatelessWidget {
  const JummaNavbarUI({super.key});

  @override
  Widget build(BuildContext context) {
    final JummaNavbarController controller = Get.put(JummaNavbarController());

    final List<Widget> screens = [
      const JummaHomeUI(),
      const AskImamUI(),
      const JummaProfileUI(),
    ];

    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          selectedItemColor: const Color(0xFF436E50),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz_outlined),
              activeIcon: Icon(Icons.quiz),
              label: 'Ask Imam',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
