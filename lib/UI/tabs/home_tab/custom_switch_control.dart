import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_home/utils/app_colors.dart';
import 'package:smart_home/utils/app_styles.dart';

class CustomSwitchControl extends StatelessWidget {
  final String title;
  final String icon;
  final bool value;
  final bool isDoorLock;
  final bool disabled;
  final bool animateLightIcon;
  final FutureOr<void> Function(bool) onChanged;

  const CustomSwitchControl({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    this.isDoorLock = false,
    this.animateLightIcon = false,
    this.disabled = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        width: double.infinity,
        constraints: BoxConstraints(minHeight: height * 0.11),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(36),
          border: BoxBorder.all(color: AppColors.primaryLight, width: 1.5),
        ),
        child: Row(
          children: [
            animateLightIcon
                ? AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                    width: height * 0.075,
                    height: height * 0.075,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: value
                          ? const Color(0xFFFFF8D9)
                          : const Color(0xFFF0F7FF),
                      boxShadow: value
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFFFFD84D,
                                ).withValues(alpha: 0.65),
                                blurRadius: 18,
                                spreadRadius: 1.5,
                              ),
                            ]
                          : null,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        value ? Icons.lightbulb : Icons.lightbulb_outline,
                        key: ValueKey(value),
                        color: value
                            ? const Color(0xFFFFC107)
                            : AppColors.lightGrayColor,
                        size: height * 0.055,
                      ),
                    ),
                  )
                : Image.asset(icon, height: height * 0.07),
            SizedBox(width: width * 0.02),
            Expanded(
              child: Text(
                title,
                style: AppStyles.bold18black,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            isDoorLock
                ? IconButton(
                    onPressed: () {
                      onChanged(!value);
                    },
                    icon: Icon(
                      value ? Icons.lock_outline_rounded : Icons.lock_open,
                      key: ValueKey(value),
                      color: Color(0xFF0D99FF),

                      size: 40,
                    ),
                  )
                : Switch(
                    value: value,
                    onChanged: disabled
                        ? null
                        : (newValue) {
                            onChanged(newValue);
                          },

                    thumbColor: WidgetStateProperty.resolveWith((states) {
                      return AppColors.whiteColor;
                    }),

                    trackColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.primaryLight; // ON
                      }
                      return AppColors.offWhiteColor; // OFF
                    }),
                  ),
          ],
        ),
      ),
    );
  }
}
