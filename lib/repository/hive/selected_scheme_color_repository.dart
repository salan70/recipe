import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/domain/type_adapter/selected_flex_scheme_index/selected_flex_scheme_index.dart';
import 'package:recipe/view/other/edit_ingredient_unit/edit_ingredient_unit_model.dart';

class SelectedSchemeColorRepository {
  EditIngredientUnitModel ingredientUnitEditModel = EditIngredientUnitModel();

  SelectedFlexSchemeIndex fetchSelectedFlexScheme() {
    final box = SelectedFlexSchemeIndexBoxes.getSelectedFlexSchemeIndex();

    // defaultValueの13はgreen
    final SelectedFlexSchemeIndex getBox = box.get('selectedFlexSchemeIndex',
        defaultValue: SelectedFlexSchemeIndex(selectedFlexSchemeIndex: 13))!;
    return getBox;
  }

  Future putSelectedFlexScheme(int selectedIndex) async {
    final box = SelectedFlexSchemeIndexBoxes.getSelectedFlexSchemeIndex();
    await box.put('selectedFlexSchemeIndex',
        SelectedFlexSchemeIndex(selectedFlexSchemeIndex: selectedIndex));
  }

  Future deleteSelectedFlexScheme() async {
    final box = SelectedFlexSchemeIndexBoxes.getSelectedFlexSchemeIndex();
    await box.delete('selectedFlexSchemeIndex');
  }
}
