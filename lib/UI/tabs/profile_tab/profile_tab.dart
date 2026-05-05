import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/UI/tabs/profile_tab/about_us_screen.dart';
import 'package:smart_home/UI/tabs/profile_tab/custom_container.dart';
import 'package:smart_home/utils/app_assets.dart';
import 'package:smart_home/utils/app_styles.dart';

import '../../../services/auth_services.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../custom_widgets/elevated_button.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : "Guest";
    // /// use the name of the user
    //     ? user!.displayName!.trim()
    // /// if the user doesn't have name,split the text that is before the '@' and use it as name
    // /// else, use the word 'guest'
    //     : (user?.email?.split('@').first ?? 'Guest');

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height*0.04),
        child: AppBar(
          toolbarHeight: height*0.06,
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          title: Text(
            'Profile',
            style: AppStyles.bold18black.copyWith(fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: AppColors.whiteColor,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: width * 0.06,
          right: width * 0.06,
          bottom: height*0.04
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.02),
            Image.asset(AppAssets.profileImage),
            SizedBox(height: height * 0.02),
            Text(
              displayName,
              style: AppStyles.bold30Black.copyWith(fontSize: 24),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: height * 0.04),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Account Info',
                style: AppStyles.bold18black.copyWith(color: AppColors.primaryLight),
              ),
            ),
            SizedBox(height: height * 0.02),
            ///username
            CustomContainer(
              title: 'Username',
              icon: AppAssets.profileIcon,
              subTitle: displayName,
            ),
            SizedBox(height: height * 0.02),
            CustomContainer(
              title: 'Email',
              icon: AppAssets.emailIcon,
              subTitle: user?.email ?? 'no user logged in',
            ),
            SizedBox(height: height * 0.04),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About Us',
                style: AppStyles.bold18black.copyWith(color: AppColors.primaryLight),
              ),
            ),
            SizedBox(height: height * 0.02),
             CustomContainer(
               title: 'About Us',
               subTitle: 'Learn more about the app',
               icon: AppAssets.aboutUsIcon,
               onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => const AboutUsScreen(),
                   ),
                 );
               },
             ),
             SizedBox(height: height*0.04,),
            CustomElevatedButton(
              backgroundColor: AppColors.whiteColor,
              hasIcon: true,
              hasBorder: true,
              shadow: false,
              foregroundColor: AppColors.redColor,
              icon: Icon(Icons.logout_outlined, color: AppColors.redColor),
              text: isLoading ? 'Logging out...' : 'Logout Account',
              onPressed: () async {
                if (!isLoading) {
                  await logout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    setState(() {
      isLoading = true;
    });

    try {
      await authService.value.signOut();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.loginRouteName,
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed'), backgroundColor: Colors.red),
      );
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }
}
