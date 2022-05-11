import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:recipe/components/providers.dart';

import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';
import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/domain/type_adapter/selected_flex_scheme_index/selected_flex_scheme_index.dart';
import 'package:recipe/repository/hive/selected_scheme_color_repository.dart';
import 'package:recipe/view/other/page_container/page_container_page.dart';
import 'package:recipe/view/setting/customize/edit_theme_color/edit_theme_color_model.dart';

//main()を非同期を制御する
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(IngredientUnitAdapter());
  Hive.registerAdapter(SelectedFlexSchemeIndexAdapter());

  await Hive.openBox<CartItem>('cartItems');
  await Hive.openBox<IngredientUnit>('ingredientUnits');
  await Hive.openBox<SelectedFlexSchemeIndex>('selectedFlexSchemeIndex');

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  // final ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// TODO 他のフォルダのmodelを呼んでいるのなんとかしたい(main_modelを作る？)
    EditThemeColorModel editThemeColorModel = EditThemeColorModel();

    return ValueListenableBuilder(
        valueListenable:
            SelectedFlexSchemeIndexBoxes.getSelectedFlexSchemeIndex()
                .listenable(),
        builder: (context, Box box, widget) {
          int usedSchemeIndex =
              editThemeColorModel.fetchSelectedFlexSchemeIndex();
          FlexScheme usedScheme =
              editThemeColorModel.flexSchemeList[usedSchemeIndex];

          Color usedSchemePrimaryColor =
              FlexThemeData.light(scheme: usedScheme).primaryColorDark;
          Color usedSchemeBackGroundColor =
              FlexThemeData.light(scheme: usedScheme).backgroundColor;

          return MaterialApp(
            title: 'Recipe App',
            theme: FlexThemeData.light(
              scheme: usedScheme,
              background: usedSchemeBackGroundColor,
              bottomAppBarElevation: 10,
            ).copyWith(
              /// textField
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: EdgeInsets.only(left: 4, bottom: 4),
                isDense: true,
              ),

              /// text
              primaryTextTheme: TextTheme(
                headline5: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                headline6: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                subtitle1: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                subtitle2: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                bodyText1: TextStyle(
                  color: Colors.black87,
                ),
              ),

              /// appBar
              appBarTheme: AppBarTheme(
                elevation: 1,
                iconTheme: IconThemeData(color: usedSchemePrimaryColor),
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: usedSchemePrimaryColor),
              ),

              /// card
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
            onGenerateRoute: (settings) {
              return MaterialWithModalsPageRoute(
                settings: settings,
                builder: (context) => PageContainerPage(),
              );
            },
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(),
          );
        });
  }
}
