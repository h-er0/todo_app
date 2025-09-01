import 'package:flutter/material.dart';

class AppColors {
  static final Color primaryColor = Colors.black;
  static final Color lightGrey = Color(0xfff2f3f5);
  static final Color grey = Color(0xffb8c2cc);
  static final Color grey1 = Color(0xffE3E7E8);
  static final Color grey2 = Color(0xffb8c2cc);
  static final Color grey3 = Color(0xffe2e5e9);

  //Light color Scheme
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
  );

  // Dark Color Scheme
  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
  );
}
