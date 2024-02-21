import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../profile_screen.dart';
import '../saved_cv.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;

  List<String> selectedIcons = [
    'assets/images/selected_chat.png',
    'assets/images/selected_heart.png',
    'assets/images/selected_profile.png',
  ];

  List<String> unselectedIcons = [
    'assets/images/unselected_chat.png',
    'assets/images/unselected_heart.png',
    'assets/images/unselected_profile.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildPage(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
selectedFontSize: 00,
        unselectedFontSize: 00,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: const Color(0xFFFFFAFA),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                _handleIconTap(0);
              },
              child: Image.asset(
                _currentIndex == 0 ? selectedIcons[0] : unselectedIcons[0],
                height: 25,
                width: 30,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                _handleIconTap(1);
              },
              child: Image.asset(
                _currentIndex == 1 ? selectedIcons[1] : unselectedIcons[1],
                height: 25,
                width: 30,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                _handleIconTap(2);
              },
              child: Image.asset(
                _currentIndex == 2 ? selectedIcons[2] : unselectedIcons[2],
                height: 25,
                width: 30,
              ),
            ),
            label: '',
          ),
        ],
      ),

    );
  }

  void _handleIconTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SavedCvScreen();
      case 2:
        return const ProfileScreen();
      default:
        return Container();
    }
  }
}
