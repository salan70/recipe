import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe/components/theme/custom_theme.dart';
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
        final usedScheme = editThemeModel.flexSchemeList[usedSchemeIndex];

        final usedThemeModeIndex = editThemeModel.fetchSelectedThemeModeIndex();
        final usedThemeMode =
            editThemeModel.themeModeList[usedThemeModeIndex].themeMode;

        return ScreenUtilInit(
          designSize: const Size(414, 896),
          builder: (context, child) {
            final customTheme = CustomTheme();
            return MaterialApp(
              themeMode: usedThemeMode,
              title: 'Recipe App',
              theme: customTheme.customLightTheme(
                usedScheme: usedScheme,
              ),
              darkTheme: customTheme.customDarkTheme(
                usedScheme: usedScheme,
              ),
              home: const PageContainerPage(),
              debugShowCheckedModeBanner: false,
              builder: EasyLoading.init(),
            );
          },
        );
      },
    );
  }
}
