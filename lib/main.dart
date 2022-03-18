import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth/auth_controller.dart';
import 'package:recipe/view/recipe_list/recipe_list_page.dart';
import 'package:recipe/sign_in/sign_in_screen.dart';

//main()を非同期を制御する
void main() async {
//アプリ起動時に処理したいので追記
  WidgetsFlutterBinding.ensureInitialized();
//Firebaseの初期化（同期）
  await Firebase.initializeApp();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // final ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    const FlexScheme usedScheme = FlexScheme.green;

    return MaterialApp(
      title: 'Recipe App',
      theme: FlexThemeData.light(
        bottomAppBarElevation: 10,
        scheme: usedScheme,
        appBarElevation: 0.5,
      ),
      // darkTheme: FlexThemeData.dark(
      //   scheme: usedScheme,
      //   appBarElevation: 2,
      // ),
      // themeMode: themeMode,
      home: RecipeListPage(),
    );
  }
}
