import 'package:recipe/repository/hive/ingredient_unit_repository.dart';

class IngredientTextFieldModel {
  List<String> fetchIngredientUnitList() {
    IngredientUnitRepository _ingredientUnitRepository =
        IngredientUnitRepository();
    final ingredientUnitList =
        _ingredientUnitRepository.fetchIngredientUnitList().ingredientUnitList;

    return ingredientUnitList;
  }
}
