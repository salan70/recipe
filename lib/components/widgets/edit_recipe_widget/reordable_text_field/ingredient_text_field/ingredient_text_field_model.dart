import 'package:recipe/repository/hive/ingredient_unit_repository.dart';

class IngredientTextFieldModel {
  List<String> fetchIngredientUnitList() {
    final ingredientUnitRepository = IngredientUnitRepository();
    final ingredientUnitList =
        ingredientUnitRepository.fetchIngredientUnitList().ingredientUnitList;

    return ingredientUnitList;
  }
}
