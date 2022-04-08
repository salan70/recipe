import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/repository/hive/ingredient_unit_repository.dart';

class IngredientTextFieldModel {
  List<String> fetchIngredientUnitList() {
    IngredientUnitRepository _ingredientUnitRepository =
        IngredientUnitRepository();
    final ingredientUnitList =
        _ingredientUnitRepository.getIngredientUnitList().ingredientUnitList;

    return ingredientUnitList;
  }
}
