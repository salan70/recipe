import 'package:hive/hive.dart';

part 'ingredient_unit.g.dart';

@HiveType(typeId: 2)
class IngredientUnit {
  @HiveField(0)
  List<String> ingredientUnitList;

  IngredientUnit({required this.ingredientUnitList});
}

class IngredientUnitBoxes {
  static Box<IngredientUnit> getIngredientUnit() =>
      Hive.box<IngredientUnit>('ingredientUnits');
}
