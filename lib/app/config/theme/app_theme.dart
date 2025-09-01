import 'package:flutter/material.dart';
import 'color_theme.dart';

class AppTheme {
  static TextStyle defaultTextStyle = TextStyle(
    fontSize: 16.0,
    decoration: TextDecoration.none,
  );

  static TextStyle defaultActionTextStyle = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
  );

  static TextStyle defaultActionSmallTextStyle = TextStyle(fontSize: 15.0);

  static TextStyle defaultTabLabelTextStyle = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );

  static TextStyle defaultSmallTitleTextStyle = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
  );

  static TextStyle defaultMiddleTitleTextStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
  );

  static TextStyle defaultLargeTitleTextStyle = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
  );

  static TextStyle defaultPickerTextStyle = TextStyle(
    fontSize: 21.0,
    fontWeight: FontWeight.w400,
  );

  static TextStyle defaultDateTimePickerTextStyle = TextStyle(
    fontSize: 21,
    letterSpacing: 0.4,
    fontWeight: FontWeight.normal,
  );

  static final lightThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.lightColorScheme,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    scaffoldBackgroundColor: Colors.white,

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final darkThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.darkColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.blueGrey.withValues(alpha: .12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
