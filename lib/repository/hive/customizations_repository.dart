import 'package:recipe/domain/type_adapter/customizations/customizations.dart';

class CustomizationsRepository {
  /// ThemeMode関連
  Customizations fetchSelectedThemeModeIndex() {
    final box = CustomizationsBoxes.getCustomizations();

    // 0：system
    final Customizations getBox = box.get('selectedThemeModeIndex',
        defaultValue: Customizations(index: 0))!;
    return getBox;
  }

  Future putSelectedThemeModeIndex(int selectedIndex) async {
    final box = CustomizationsBoxes.getCustomizations();
    await box.put(
        'selectedThemeModeIndex', Customizations(index: selectedIndex));
  }

  Future deleteSelectedThemeModeIndex() async {
    final box = CustomizationsBoxes.getCustomizations();
    await box.delete('selectedThemeModeIndex');
  }

  /// FlexScheme関連
  Customizations fetchSelectedFlexSchemeIndex() {
    final box = CustomizationsBoxes.getCustomizations();

    // 13：green
    final Customizations getBox = box.get('selectedFlexSchemeIndex',
        defaultValue: Customizations(index: 13))!;
    return getBox;
  }

  Future putSelectedFlexScheme(int selectedIndex) async {
    final box = CustomizationsBoxes.getCustomizations();
    await box.put(
        'selectedFlexSchemeIndex', Customizations(index: selectedIndex));
  }

  Future deleteSelectedFlexScheme() async {
    final box = CustomizationsBoxes.getCustomizations();
    await box.delete('selectedFlexSchemeIndex');
  }
}
