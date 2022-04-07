import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/view/other/ingredient_unit_edit/ingredient_unit_edit_model.dart';

class IngredientUnitRepository {
  IngredientUnitEditModel ingredientUnitEditModel = IngredientUnitEditModel();

  IngredientUnit getIngredientUnitList() {
    final defaultIngredientUnitList =
        ingredientUnitEditModel.defaultIngredientUnitList;

    final box = IngredientUnitBoxes.getIngredientUnit();
    final IngredientUnit getBox = box.get('ingredientUnitList',
        defaultValue:
            IngredientUnit(ingredientUnitList: defaultIngredientUnitList))!;
    return getBox;
  }

  Future putIngredientUnitList(List<String> ingredientUnitList) async {
    final box = IngredientUnitBoxes.getIngredientUnit();
    await box.put('ingredientUnitList',
        IngredientUnit(ingredientUnitList: ingredientUnitList));
  }

  Future deleteIngredientUnitList() async {
    final box = IngredientUnitBoxes.getIngredientUnit();
    await box.delete('ingredientUnitList');
  }
}
