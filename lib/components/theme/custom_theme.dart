import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTheme {
  InputDecorationTheme customInputDecoration() {
    return InputDecorationTheme(
      contentPadding: const EdgeInsets.only(left: 4, bottom: 4).r,
      isDense: true,
    );
  }

  TextTheme customTextTheme({
    required Color mainTextColor,
    required Color hintTextColor,
  }) {
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
