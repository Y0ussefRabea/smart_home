import 'package:flutter/material.dart';
import 'package:smart_home/utils/app_assets.dart';

import '../../../models/notification_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';
class CustomNotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const CustomNotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final config = getConfig(notification.type);

    return Container(
      height: height*0.11,
      margin:  EdgeInsets.only(bottom: height*0.02),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height*0.01,),
      decoration: BoxDecoration(
        color: AppColors.iceBlueColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.15,
            height: width * 0.15,
            child: Image.asset(
              config['image'],
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: width*0.03),
          Expanded(
            child: Text(
              notification.title,
              style: AppStyles.bold14black.copyWith(fontSize: 16),
            ),
          ),
          Text(
            formatTime(notification.time),
            style: AppStyles.regular14Gray,
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> getConfig(String type) {
    switch (type) {
      case 'gas':
        return {
          'image':AppAssets.gasIcon2,
        };
      case 'door':
        return {
          'image': AppAssets.lockIcon,
        };
      case 'temp':
      default:
        return {
          'image': AppAssets.highTempIcon
        };
    }
  }

  String formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes <1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
