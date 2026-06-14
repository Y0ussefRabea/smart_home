import 'package:flutter/material.dart';
import 'package:smart_home/utils/app_colors.dart';
import 'package:smart_home/utils/app_styles.dart';

class CustomDataCard extends StatelessWidget {
  final String imageIcon;
  final String text;
  final String statusText;
  final bool isGasCard;
  final bool gasSafe;

  const CustomDataCard({
    super.key,
    required this.imageIcon,
    required this.text,
    required this.statusText,
    this.isGasCard = false,
    this.gasSafe = true,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final bool isAlert = isGasCard && !gasSafe;

    return Container(
      padding: EdgeInsets.only(
        top: height * 0.03,
        left: width * 0.04,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        color: isAlert ? Colors.red.shade100 : Colors.white,
        border: Border.all(
          color: isAlert ? Colors.red : AppColors.primaryLight,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imageIcon, width: 20),
          const SizedBox(height: 4),
          Text(
            text,
            style: AppStyles.medium14Gray,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            alignment: Alignment.centerLeft,
            child: Text(
              statusText,
              style: AppStyles.bold30Black.copyWith(
                fontSize: 28,
                color: isAlert ? Colors.red : Colors.black,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}