import 'package:flutter/material.dart';
import 'package:smart_home/utils/app_colors.dart';
import 'package:smart_home/utils/app_styles.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.whiteColor,
        title: Text('Notifications',style: AppStyles.bold18black.copyWith(fontSize: 20),),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.symmetric(
              vertical: height*0.02,
              horizontal: width*0.05
          ),
          child: Column(
            children: [
              Text('Recent Activity',style: AppStyles.bold14Primary.copyWith(fontSize: 30),)
            ],
          ),
        ),
      ),
    );
  }
}
