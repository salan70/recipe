import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';
import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/view/other/page_container/page_container_page.dart';

//main()を非同期を制御する
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(IngredientUnitAdapter());

  await Hive.openBox<CartItem>('cartItems');
  await Hive.openBox<IngredientUnit>('ingredientUnits');

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // final ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    const FlexScheme usedScheme = FlexScheme.green;
    Color usedSchemePrimaryColor =
        FlexColorScheme.light(scheme: usedScheme).primary!;

    return MaterialApp(
      title: 'Recipe App',
      theme: FlexThemeData.light(
        scheme: usedScheme,
        bottomAppBarElevation: 10,
        primaryTextTheme: TextTheme(
          subtitle1: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ).copyWith(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: usedSchemePrimaryColor),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: usedSchemePrimaryColor),
        ),
        cardTheme: CardTheme(
          margin: EdgeInsets.all(8),
          elevation: 3,
        ),
      ),
      // darkTheme: FlexThemeData.dark(
      //   scheme: usedScheme,
      //   appBarElevation: 2,
      // ),
      // themeMode: themeMode,
      home: PageContainerPage(),
    );
  }
}
