import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTheme {
  AppBarTheme customAppBarTheme({
    required ThemeMode themeMode,
    required FlexScheme usedScheme,
  }) {
    return AppBarTheme(
      elevation: 1,
      iconTheme: IconThemeData(
        color: themeMode == ThemeMode.light
            ? FlexThemeData.light(scheme: usedScheme).primaryColorDark
            : FlexThemeData.dark(scheme: usedScheme).primaryColorDark,
      ),
      backgroundColor:
          themeMode == ThemeMode.light ? Colors.white : Colors.black,
      titleTextStyle: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: themeMode == ThemeMode.light
            ? FlexThemeData.light(scheme: usedScheme).primaryColorDark
            : FlexThemeData.dark(scheme: usedScheme).primaryColorDark,
      ),
    );
  }

  InputDecorationTheme customInputDecoration() {
    return InputDecorationTheme(
      contentPadding: const EdgeInsets.only(left: 4, bottom: 4).r,
      isDense: true,
    );
  }

  CardTheme customCardTheme() {
    return CardTheme(
      margin: const EdgeInsets.all(8).r,
      elevation: 3,
    );
  }

  TextTheme customTextTheme({
    required ThemeMode themeMode,
  }) {
    final mainTextColor =
        themeMode == ThemeMode.light ? Colors.black : Colors.white;
    final hintTextColor =
        themeMode == ThemeMode.light ? Colors.black54 : Colors.white54;

    return TextTheme(
      headline1: TextStyle(
        fontSize: 96.sp,
        color: mainTextColor,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        fontSize: 60.sp,
        color: mainTextColor,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        fontSize: 48.sp,
        color: mainTextColor,
        fontWeight: FontWeight.bold,
      ),
      headline4: TextStyle(
        fontSize: 34.sp,
        color: mainTextColor,
        fontWeight: FontWeight.bold,
      ),
      headline5: TextStyle(
        fontSize: 24.sp,
        color: mainTextColor,
        fontWeight: FontWeight.bold,
      ),
      headline6: TextStyle(
        fontSize: 20.sp,
        color: mainTextColor,
        fontWeight: FontWeight.bold,
      ),
      // TextFieldに使用される(TextField以外では基本使わない)
      subtitle1: TextStyle(
        fontSize: 16.sp,
        color: mainTextColor,
      ),
      // 小見出し(ListTileのtitleなど)に使用する
      subtitle2: TextStyle(
        fontSize: 16.sp,
        color: mainTextColor,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        fontSize: 16.sp,
        color: mainTextColor,
      ),
      // 通常のテキストに使用する
      bodyText2: TextStyle(
        fontSize: 14.sp,
        color: mainTextColor,
      ),
      caption: TextStyle(
        fontSize: 12.sp,
        color: hintTextColor,
      ),
      overline: TextStyle(
        fontSize: 10.sp,
        color: mainTextColor,
      ),
    );
  }
}
