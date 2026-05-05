import 'package:flutter/material.dart';
import 'package:smart_home/utils/app_colors.dart';
import 'package:smart_home/utils/app_styles.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text(
          'About Us',
          style: AppStyles.bold18black,
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.06,
          vertical: height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context),
            SizedBox(height: height * 0.025),
            Text(
              'What We Do',
              style: AppStyles.bold18black.copyWith(color: AppColors.primaryLight),
            ),
            SizedBox(height: height * 0.012),
            Text(
              'Smart Home helps you monitor and control your home devices from one place. '
              'The app is designed to keep your home simple, connected, and efficient.',
              style: AppStyles.regular16Gray.copyWith(height: 1.5),
            ),
            SizedBox(height: height * 0.025),
            Text(
              'Core Features',
              style: AppStyles.bold18black.copyWith(color: AppColors.primaryLight),
            ),
            SizedBox(height: height * 0.012),
            _buildFeatureTile(
              icon: Icons.lightbulb_outline_rounded,
              title: 'Device Control',
              description: 'Manage connected devices quickly with clear, user-friendly controls.',
            ),
            _buildFeatureTile(
              icon: Icons.auto_awesome_outlined,
              title: 'Smart Automation',
              description: 'Set routines to make your home react automatically to your daily needs.',
            ),
            _buildFeatureTile(
              icon: Icons.security_outlined,
              title: 'Reliable Experience',
              description: 'Built with a focus on performance, stability, and account security.',
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0C8CE9), Color(0xFF007BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(
              Icons.home_work_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(height: height * 0.015),
          Text(
            'Smart Home',
            style: AppStyles.bold18black.copyWith(
              color: AppColors.whiteColor,
              fontSize: 24,
            ),
          ),
          SizedBox(height: height * 0.008),
          Text(
            'Control your home, simplify your life.',
            style: AppStyles.medium14Gray.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.iceBlueColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryLight,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bold14black.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppStyles.regular14Gray.copyWith(height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
