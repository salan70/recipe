import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTheme {
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
      subtitle1: TextStyle(
        fontSize: 16.sp,
        // color: Colors.red,
        color: mainTextColor,
        fontWeight: FontWeight.bold,
      ),
      subtitle2: TextStyle(
        fontSize: 14.sp,
        color: mainTextColor,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        fontSize: 16.sp,
        color: mainTextColor,
      ),
      bodyText2: TextStyle(
        fontSize: 14.sp,
        color: mainTextColor,
      ),
      caption: TextStyle(
        fontSize: 12.sp,
        color: Colors.green,
        // color: hintTextColor,
      ),
      overline: TextStyle(
        fontSize: 10.sp,
        color: mainTextColor,
      ),
    );
  }
}
