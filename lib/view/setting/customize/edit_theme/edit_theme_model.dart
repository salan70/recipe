import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:recipe/domain/custom_theme_mode.dart';
import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/repository/hive/ingredient_unit_repository.dart';
import 'package:recipe/repository/hive/customizations_repository.dart';

class EditThemeModel {
  final List<CustomThemeMode> themeModeList = [
    CustomThemeMode(themeMode: ThemeMode.system, themeModeName: 'デバイスに合わせる'),
    CustomThemeMode(themeMode: ThemeMode.light, themeModeName: 'ライト'),
    CustomThemeMode(themeMode: ThemeMode.dark, themeModeName: 'ダーク'),
  ];

  final List<FlexScheme> flexSchemeList = [
    FlexScheme.material,
    FlexScheme.materialHc,
    FlexScheme.blue,
    FlexScheme.indigo,
    FlexScheme.hippieBlue,
    FlexScheme.aquaBlue,
    FlexScheme.brandBlue,
    FlexScheme.deepBlue,
    FlexScheme.sakura,
    FlexScheme.mandyRed,
    FlexScheme.red,
    FlexScheme.redWine,
    FlexScheme.purpleBrown,
    FlexScheme.green,
    FlexScheme.money,
    FlexScheme.jungle,
    FlexScheme.greyLaw,
    FlexScheme.wasabi,
    FlexScheme.gold,
    FlexScheme.mango,
    FlexScheme.amber,
    FlexScheme.vesuviusBurn,
    FlexScheme.deepPurple,
    FlexScheme.ebonyClay,
    FlexScheme.barossa,
    FlexScheme.shark,
    FlexScheme.bigStone,
    FlexScheme.damask,
    FlexScheme.bahamaBlue,
    FlexScheme.mallardGreen,
    FlexScheme.espresso,
    FlexScheme.outerSpace,
    FlexScheme.blueWhale,
    FlexScheme.sanJuanBlue,
    FlexScheme.rosewood,
    FlexScheme.blumineBlue,
  ];

  /// ThemeMode関連
  int fetchSelectedThemeModeIndex() {
    CustomizationsRepository _repository = CustomizationsRepository();
    final selectedThemeModeIndex =
        _repository.fetchSelectedThemeModeIndex().index;
    return selectedThemeModeIndex;
  }

  Future editSelectedThemeModeIndex(int selectedIndex) async {
    CustomizationsRepository _repository = CustomizationsRepository();

    await _repository.putSelectedThemeModeIndex(selectedIndex);
  }

  /// FlexScheme関連
  int fetchSelectedFlexSchemeIndex() {
    CustomizationsRepository _repository = CustomizationsRepository();
    final selectedFlexSchemeIndex =
        _repository.fetchSelectedFlexSchemeIndex().index;
    return selectedFlexSchemeIndex;
  }

  Future editSelectedFlexSchemeIndex(int selectedIndex) async {
    CustomizationsRepository _repository = CustomizationsRepository();

    await _repository.putSelectedFlexScheme(selectedIndex);
  }
}
