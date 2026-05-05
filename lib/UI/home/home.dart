import 'package:flutter/material.dart';
import 'package:smart_home/utils/app_colors.dart';

import '../tabs/home_tab/home_tab.dart';
import '../tabs/notifications_tab/notifications_tab.dart';
import '../tabs/profile_tab/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
List<Widget> tabs=[HomeTab(),NotificationsTab(),ProfileTab()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.whiteColor,
      body: tabs[selectedIndex],

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          backgroundColor: AppColors.iceBlueColor,
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.lightGrayColor,
          elevation: 8,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
