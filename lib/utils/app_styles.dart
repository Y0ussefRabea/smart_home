import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';


class AppStyles{
  static TextStyle bold30Black=GoogleFonts.inter(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AppColors.blackColor
  );
  static TextStyle bold14black=GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.blackColor
  );
  static TextStyle bold18black=GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.blackColor
  );
  static TextStyle bold14Primary=GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.primaryLight
  );
  static TextStyle bold16Gray=GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.grayColor
  );
  static TextStyle bold16White=GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.whiteColor
  );
  static TextStyle medium14Gray=GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.grayColor
  );
  static TextStyle medium14Primary=GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryLight
  );
  static TextStyle regular16Gray=GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.grayColor
  );
  static TextStyle regular14Gray=GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.grayColor
  );
}

/*

| ------ | ----------- |
| w100   | Thin        |
| w200   | Extra Light |
| w300   | Light       |
| w400   | Regular     |
| w500   | Medium      |
| w600   | Semi Bold   |
| w700   | Bold        |
| w800   | Extra Bold  |
| w900   | Black       |

 */