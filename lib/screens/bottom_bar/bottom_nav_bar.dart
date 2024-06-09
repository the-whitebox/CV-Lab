import 'package:crewdog_cv_lab/screens/job_search.dart';
import 'package:crewdog_cv_lab/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home_screen.dart';
import '../profile_screen.dart';
import '../saved_cv.dart';

class BottomBarController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    // if (currentIndex.value == 1 && index != 1) {
    //  final controller=Get.put(TempController());
    //  controller.refreshController();
    // }
    currentIndex.value = index;
  }
}

class BottomBar extends StatelessWidget {
  final BottomBarController controller = Get.put(BottomBarController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Center(
            child: buildPage(controller.currentIndex.value),
          ),
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: const Color(0xFFFFFAFA),
            currentIndex: controller.currentIndex.value,
            onTap: (index) {
              controller.changePage(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  size: 30,
                  Icons.search_outlined,
                  color: controller.currentIndex.value == 0 ? kHighlightedColor : Colors.black87,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  controller.currentIndex.value == 1 ? 'assets/images/selected_chat.png' : 'assets/images/unselected_chat.png',
                  height: 25,
                  width: 30,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  controller.currentIndex.value == 2 ? 'assets/images/selected_heart.png' : 'assets/images/unselected_heart.png',
                  height: 25,
                  width: 30,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  controller.currentIndex.value == 3 ? 'assets/images/selected_profile.png' : 'assets/images/unselected_profile.png',
                  height: 25,
                  width: 30,
                ),
                label: '',
              ),
            ],
          ),
        ));
  }

  Widget buildPage(int index) {
    switch (index) {
      case 0:
        return const JobSearchScreen();
      case 1:
        return const HomeScreen();
      case 2:
        return const SavedCvScreen();
      case 3:
        return const ProfileScreen();
      default:
        return Container();
    }
  }
}
