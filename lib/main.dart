import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';
import 'package:recipe/domain/type_adapter/customizations/customizations.dart';
import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/view/other/page_container/page_container_page.dart';
import 'view/setting/customize/edit_theme/edit_theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 画面の向きを固定
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(IngredientUnitAdapter());
  Hive.registerAdapter(CustomizationsAdapter());

  await Hive.openBox<CartItem>('cartItems');
  await Hive.openBox<IngredientUnit>('ingredientUnits');
  await Hive.openBox<Customizations>('customizations');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editThemeModel = EditThemeModel();

    return ValueListenableBuilder(
      valueListenable: CustomizationsBoxes.getCustomizations().listenable(),
      builder: (context, box, widget) {
        final usedSchemeIndex = editThemeModel.fetchSelectedFlexSchemeIndex();
        final usedThemeModeIndex = editThemeModel.fetchSelectedThemeModeIndex();
        final usedThemeMode =
            editThemeModel.themeModeList[usedThemeModeIndex].themeMode;

        final usedScheme = editThemeModel.flexSchemeList[usedSchemeIndex];

        return ScreenUtilInit(
          designSize: const Size(414, 896),
          builder: (context, child) {
            return MaterialApp(
              themeMode: usedThemeMode,
              title: 'Recipe App',
              theme: FlexThemeData.light(
                scheme: usedScheme,
                background:
                    FlexThemeData.light(scheme: usedScheme).backgroundColor,
                bottomAppBarElevation: 10,
              ).copyWith(
                /// textField
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding: const EdgeInsets.only(left: 4, bottom: 4).r,
                  isDense: true,
                ),

                /// text
                primaryTextTheme: TextTheme(
                  headline5: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  headline6: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle1: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle2: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyText1: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                  caption: TextStyle(
                    fontSize: 12.sp,
                    color: FlexThemeData.light(scheme: usedScheme).hintColor,
                  ),
                ),

                /// appBar
                appBarTheme: AppBarTheme(
                  elevation: 1,
                  iconTheme: IconThemeData(
                      color: FlexThemeData.light(scheme: usedScheme)
                          .primaryColorDark),
                  backgroundColor: Colors.white,
                  titleTextStyle: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: FlexThemeData.light(scheme: usedScheme)
                        .primaryColorDark,
                  ),
                ),

                /// card
                cardTheme: CardTheme(
                  margin: const EdgeInsets.all(8).r,
                  elevation: 3,
                ),
              ),
              darkTheme: FlexThemeData.dark(
                scheme: usedScheme,
                background:
                    FlexThemeData.dark(scheme: usedScheme).backgroundColor,
                bottomAppBarElevation: 10,
              ).copyWith(
                /// textField
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding: const EdgeInsets.only(left: 4, bottom: 4).r,
                  isDense: true,
                ),

                /// text
                primaryTextTheme: TextTheme(
                  headline5: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  headline6: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle1: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle2: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyText1: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                  caption: TextStyle(
                    fontSize: 12.sp,
                    color: FlexThemeData.dark(scheme: usedScheme).hintColor,
                  ),
                ),

                /// appBar
                appBarTheme: AppBarTheme(
                  elevation: 1,
                  iconTheme: IconThemeData(
                      color: FlexThemeData.dark(scheme: usedScheme)
                          .primaryColorDark),
                  backgroundColor: Colors.black,
                  titleTextStyle: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color:
                        FlexThemeData.dark(scheme: usedScheme).primaryColorDark,
                  ),
                ),

                /// card
                cardTheme: CardTheme(
                  margin: const EdgeInsets.all(8).r,
                  elevation: 3,
                ),
              ),
              onGenerateRoute: (settings) {
                return MaterialWithModalsPageRoute<PageContainerPage>(
                  settings: settings,
                  builder: (context) => const PageContainerPage(),
                );
              },
              debugShowCheckedModeBanner: false,
              builder: EasyLoading.init(),
            );
          },
        );
      },
    );
  }
}
