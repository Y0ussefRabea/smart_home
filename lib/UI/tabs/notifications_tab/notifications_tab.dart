import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/providers/smart_home_provider.dart';
import 'package:smart_home/models/notification_model.dart';
import 'package:smart_home/utils/app_colors.dart';
import 'package:smart_home/utils/app_styles.dart';

import 'notification_card.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<SmartHomeProvider>().notifications;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.whiteColor,
        title: Text('Notifications', style: AppStyles.bold18black.copyWith(fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: height * 0.02,
            horizontal: width * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recent Activity',
                  style: AppStyles.bold14Primary.copyWith(fontSize: 30)),
              SizedBox(height: height * 0.02),
              if (notifications.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: height * 0.1),
                    child: Text('No notifications yet',
                        style: AppStyles.regular16Gray),
                  ),
                )
              else
                ...notifications.map((n) => CustomNotificationCard(notification: n)),
            ],
          ),
        ),
      ),
    );
  }
}

