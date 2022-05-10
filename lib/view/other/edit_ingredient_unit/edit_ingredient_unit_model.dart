import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/repository/hive/ingredient_unit_repository.dart';

class EditIngredientUnitModel {
  final List<String> defaultIngredientUnitList = [
    '個',
    '本',
    'g',
    'kg',
    '大さじ',
    '小さじ',
    'cc',
    'l',
    'ml',
    '束',
    '袋',
    'かけら',
    'つまみ',
    '適量',
    '少々',
    'お好み',
    '杯',
    '斤',
    '房',
  ];

  List<String> fetchIngredientUnitList() {
    IngredientUnitRepository _ingredientUnitRepository =
        IngredientUnitRepository();
    final ingredientUnitList =
        _ingredientUnitRepository.getIngredientUnitList().ingredientUnitList;
    return ingredientUnitList;
  }

  String? outputAddError(String? unitName) {
    if (unitName == null || unitName == '') {
      return '入力されていません';
    } else if (checkIsDuplicate(unitName)) {
      return '$unitNameは既にあります';
    } else {
      return null;
    }
  }

  Future addIngredientUnit(String unitName) async {
    IngredientUnitRepository _ingredientUnitRepository =
        IngredientUnitRepository();
    final List<String> ingredientUnitList =
        _ingredientUnitRepository.getIngredientUnitList().ingredientUnitList;

    ingredientUnitList.add(unitName);
    await _ingredientUnitRepository.putIngredientUnitList(ingredientUnitList);
  }

  Future deleteIngredientUnit(String unitName) async {
    IngredientUnitRepository _ingredientUnitRepository =
        IngredientUnitRepository();
    final List<String> ingredientUnitList =
        _ingredientUnitRepository.getIngredientUnitList().ingredientUnitList;

    for (int index = 0; index < ingredientUnitList.length; index++) {
      if (ingredientUnitList[index] == unitName) {
        ingredientUnitList.removeAt(index);
        break;
      }
    }
    await _ingredientUnitRepository.putIngredientUnitList(ingredientUnitList);
    // print('after delete:$ingredientUnitList');
  }

  Future deleteIngredientUnitList() async {
    IngredientUnitRepository _ingredientUnitRepository =
        IngredientUnitRepository();
    await _ingredientUnitRepository.deleteIngredientUnitList();
  }

  Future reorderIngredientUnitList(int oldIndex, int newIndex) async {
    IngredientUnitRepository _ingredientUnitRepository =
        IngredientUnitRepository();
    final List<String> ingredientUnitList =
        _ingredientUnitRepository.getIngredientUnitList().ingredientUnitList;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    String ingredientUnit = ingredientUnitList.removeAt(oldIndex);

    ingredientUnitList.insert(newIndex, ingredientUnit);
    await _ingredientUnitRepository.putIngredientUnitList(ingredientUnitList);
  }

  bool checkIsDuplicate(String unitName) {
    IngredientUnitRepository _ingredientUnitRepository =
        IngredientUnitRepository();
    final List<String> ingredientUnitList =
        _ingredientUnitRepository.getIngredientUnitList().ingredientUnitList;

    for (var ingredientUnit in ingredientUnitList) {
      if (ingredientUnit == unitName) {
        return true;
      }
    }
    return false;
  }
}
