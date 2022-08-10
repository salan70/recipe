import '../../domain/type_adapter/customizations/customizations.dart';

class CustomizationsRepository {
  /// ThemeMode関連
  Customizations fetchSelectedThemeModeIndex() {
    final box = CustomizationsBoxes.getCustomizations();

    // 0：system
    final getBox = box.get(
      'selectedThemeModeIndex',
      defaultValue: Customizations(index: 0),
    )!;
    return getBox;
  }

  Future<void> putSelectedThemeModeIndex(int selectedIndex) async {
    final box = CustomizationsBoxes.getCustomizations();
    await box.put(
      'selectedThemeModeIndex',
      Customizations(index: selectedIndex),
    );
  }

  Future<void> deleteSelectedThemeModeIndex() async {
    final box = CustomizationsBoxes.getCustomizations();
    await box.delete('selectedThemeModeIndex');
  }

  /// FlexScheme関連
  Customizations fetchSelectedFlexSchemeIndex() {
    final box = CustomizationsBoxes.getCustomizations();

    // 13：green
    final getBox = box.get(
      'selectedFlexSchemeIndex',
      defaultValue: Customizations(index: 13),
    )!;
    return getBox;
  }

  Future<void> putSelectedFlexScheme(int selectedIndex) async {
    final box = CustomizationsBoxes.getCustomizations();
    await box.put(
      'selectedFlexSchemeIndex',
      Customizations(index: selectedIndex),
    );
  }

  Future<void> deleteSelectedFlexScheme() async {
    final box = CustomizationsBoxes.getCustomizations();
    await box.delete('selectedFlexSchemeIndex');
  }
}
