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
    '合',
    '枚',
    '缶',
    '粒',
    '束',
    '袋',
    'パック',
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
    final ingredientUnitRepository = IngredientUnitRepository();
    final ingredientUnitList =
        ingredientUnitRepository.fetchIngredientUnitList().ingredientUnitList;
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

  Future<void> addIngredientUnit(String unitName) async {
    final ingredientUnitRepository = IngredientUnitRepository();
    final ingredientUnitList = ingredientUnitRepository
        .fetchIngredientUnitList()
        .ingredientUnitList
      ..add(unitName);

    await ingredientUnitRepository.putIngredientUnitList(ingredientUnitList);
  }

  Future<bool> deleteIngredientUnit(String unitName) async {
    final ingredientUnitRepository = IngredientUnitRepository();
    final ingredientUnitList =
        ingredientUnitRepository.fetchIngredientUnitList().ingredientUnitList;

    // 単位が1つしかない場合、削除できない
    if (ingredientUnitList.length == 1) {
      return false;
    }
    for (var index = 0; index < ingredientUnitList.length; index++) {
      if (ingredientUnitList[index] == unitName) {
        ingredientUnitList.removeAt(index);
        break;
      }
    }
    await ingredientUnitRepository.putIngredientUnitList(ingredientUnitList);
    return true;
  }

  Future<void> deleteIngredientUnitList() async {
    final ingredientUnitRepository = IngredientUnitRepository();
    await ingredientUnitRepository.deleteIngredientUnitList();
  }

  Future<void> reorderIngredientUnitList(int oldIndex, int newIndex) async {
    final ingredientUnitRepository = IngredientUnitRepository();
    final ingredientUnitList =
        ingredientUnitRepository.fetchIngredientUnitList().ingredientUnitList;

    var useNewIndex = newIndex;

    if (oldIndex < useNewIndex) {
      useNewIndex -= 1;
    }
    final ingredientUnit = ingredientUnitList.removeAt(oldIndex);

    ingredientUnitList.insert(useNewIndex, ingredientUnit);
    await ingredientUnitRepository.putIngredientUnitList(ingredientUnitList);
  }

  bool checkIsDuplicate(String unitName) {
    final ingredientUnitRepository = IngredientUnitRepository();
    final ingredientUnitList =
        ingredientUnitRepository.fetchIngredientUnitList().ingredientUnitList;

    for (final ingredientUnit in ingredientUnitList) {
      if (ingredientUnit == unitName) {
        return true;
      }
    }
    return false;
  }
}
