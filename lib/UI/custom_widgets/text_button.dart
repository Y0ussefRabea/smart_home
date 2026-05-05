import 'package:flutter/material.dart';

import '../../utils/app_styles.dart';

class CustomTextButton extends StatelessWidget {
  String text;
  Alignment alignment;
  final VoidCallback? onPressed;
  CustomTextButton({
    super.key,
    required this.text,
    this.alignment=Alignment.centerRight,
    required this.onPressed
  })
  ;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style:AppStyles.bold14Primary,
          )
      ),
    );
  }
}
