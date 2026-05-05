import 'package:flutter/material.dart';
import 'package:smart_home/utils/app_styles.dart';

import '../../utils/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  String text;
  VoidCallback onPressed;
  Color backgroundColor;
  Color foregroundColor;
  Icon? icon;
  bool hasIcon;
  bool hasBorder;
  bool shadow;

  CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryLight,
    this.foregroundColor = AppColors.whiteColor,
    this.shadow = true,
    this.hasIcon=false,
    this.hasBorder=false,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.infinity,
      height: height * 0.075,
      child: ElevatedButton.icon(
         icon: hasIcon?icon:null,

        onPressed: onPressed,
        style: ElevatedButton.styleFrom(

          shadowColor: shadow ? AppColors.primaryLight : null,
          elevation:shadow ? 5:null,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2,
              color:hasIcon?AppColors.redColor:Colors.transparent
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: AppStyles.bold16White,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor, //for the text color

        ),
         label: Text(text),

      ),
    );
  }
}
