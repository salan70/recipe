import 'package:fraction/fraction.dart';
import 'package:recipe/domain/recipe.dart';

class Validations {
  /// レシピのvalidation
  String? outputRecipeErrorText(
      Recipe recipe, List<Ingredient> ingredientList) {
    if (!_isEnteredString(recipe.recipeName)) {
      return 'レシピ名を入力してください';
    } else if (!_isEnteredInt(recipe.forHowManyPeople)) {
      return '材料が何人分か入力してください';
    } else if (!_isGraterThanZero(recipe.forHowManyPeople!)) {
      return '材料は1人分以上で入力してください';
    } else {
      for (var ingredient in ingredientList) {
        if (_isEnteredString(ingredient.name) &&
            !_isEnteredString(ingredient.unit)) {
          return '単位が選択されていない材料があります';
        }
        if (outputAmountErrorText(ingredient.amount) != null) {
          return '材料の数量に不正な値があります';
        }
      }
    }
    return null;
  }

  bool _isEnteredString(String? recipeName) {
    if (recipeName == null || recipeName == '') {
      return false;
    } else {
      return true;
    }
  }

  bool _isEnteredInt(int? forHowManyPeople) {
    if (forHowManyPeople == null) {
      return false;
    } else {
      return true;
    }
  }

  bool _isGraterThanZero(int forHowManyPeople) {
    if (forHowManyPeople > 0) {
      return true;
    } else {
      return false;
    }
  }

  /// 材料の数量関連のvalidation
  String? outputAmountErrorText(String? ingredientAmount) {
    if (ingredientAmount == null || ingredientAmount == '') {
      return null;
    } else if (_isPositiveDouble(ingredientAmount) == false &&
        _isPositiveFraction(ingredientAmount) == false) {
      return '値が不正です';
    } else {
      return null;
    }
  }

  // 0以上かつdouble型にキャストできるか検証
  bool _isPositiveDouble(String ingredientAmount) {
    try {
      double num = double.parse(ingredientAmount);
      if (num >= 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // 0以上かつ、fraction型かmixedFraction型にキャストできるか検証
  bool _isPositiveFraction(String ingredientAmount) {
    try {
      final _fraction = Fraction.fromString(ingredientAmount);
      if (_fraction.toDouble() >= 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      try {
        final _mixedFraction = MixedFraction.fromString(ingredientAmount);
        if (_mixedFraction.toDouble() >= 0) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }
  }
}
