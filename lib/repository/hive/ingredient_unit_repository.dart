import '../../domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import '../../view/other/edit_ingredient_unit/edit_ingredient_unit_model.dart';

class IngredientUnitRepository {
  EditIngredientUnitModel ingredientUnitEditModel = EditIngredientUnitModel();

  IngredientUnit fetchIngredientUnitList() {
    final defaultIngredientUnitList =
        ingredientUnitEditModel.defaultIngredientUnitList;

    final box = IngredientUnitBoxes.getIngredientUnit();
    final getBox = box.get(
      'ingredientUnitList',
      defaultValue:
          IngredientUnit(ingredientUnitList: defaultIngredientUnitList),
    )!;
    return getBox;
  }

  Future<void> putIngredientUnitList(List<String> ingredientUnitList) async {
    final box = IngredientUnitBoxes.getIngredientUnit();
    await box.put(
      'ingredientUnitList',
      IngredientUnit(ingredientUnitList: ingredientUnitList),
    );
  }

  Future<void> deleteIngredientUnitList() async {
    final box = IngredientUnitBoxes.getIngredientUnit();
    await box.delete('ingredientUnitList');
  }
}
