import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/repository/hive/ingredient_unit_repository.dart';
import 'package:recipe/repository/hive/selected_scheme_color_repository.dart';

class EditThemeColorModel {
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

  int fetchSelectedFlexSchemeIndex() {
    SelectedSchemeColorRepository _selectedSchemeColorRepository =
        SelectedSchemeColorRepository();
    final selectedFlexSchemeIndex = _selectedSchemeColorRepository
        .fetchSelectedFlexScheme()
        .selectedFlexSchemeIndex;
    return selectedFlexSchemeIndex;
  }

  Future editSelectedFlexScheme(int selectedIndex) async {
    SelectedSchemeColorRepository _selectedSchemeColorRepository =
        SelectedSchemeColorRepository();

    // await _selectedSchemeColorRepository.deleteSelectedFlexScheme();
    await _selectedSchemeColorRepository.putSelectedFlexScheme(selectedIndex);
  }
}
