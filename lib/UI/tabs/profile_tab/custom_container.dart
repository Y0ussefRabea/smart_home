import 'package:flutter/material.dart';

import '../../../utils/app_styles.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final String icon;
  final String? subTitle;
  final VoidCallback? onTap;

  const CustomContainer({
    super.key,
    required this.title,
    required this.icon,
    this.subTitle,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFD1E2F1),
          borderRadius: BorderRadius.circular(36),
        ),
        width: double.infinity,
        constraints: BoxConstraints(minHeight: height * 0.09),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(icon,height: height*0.06,),
            SizedBox(width: width*0.03,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,style: AppStyles.bold18black.copyWith(fontSize: 16),),
                  Text(
                    subTitle ?? '',
                    style: AppStyles.medium14Gray,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black.withOpacity(0.6),
              ),
          ],
        ),
      ),
    );
  }
}
