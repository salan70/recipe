import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe/components/type_adapter/cart_checkbox.dart';
import 'package:recipe/view/other/page_container/page_container_page.dart';

//main()を非同期を制御する
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();

  Hive.registerAdapter(CartCheckBoxAdapter());

  await Hive.openBox('settings');
  await Hive.openBox('checkBox');

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
      // home: RecipeListPage(),
      home: PageContainerPage(),
    );
  }
}
