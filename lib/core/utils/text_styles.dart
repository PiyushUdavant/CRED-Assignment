import 'package:cred_application/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle s9W500Red = GoogleFonts.inter(
    fontSize :  10,
    fontWeight: FontWeight.w500,
    color : redColor
  );

  static TextStyle s12H120W400 = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle s12W400Secondary = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static TextStyle s12H120W500 = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle s12W500Red = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: redColor,
  );

  static TextStyle s12H120W700 = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static TextStyle s12W700White = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );

  static TextStyle s14H120W600 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static TextStyle s16H120W700 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle s16W700Primary = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static TextStyle s17W700Primary = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: textSecondary,
  );

  static TextStyle s18H120W700 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

}