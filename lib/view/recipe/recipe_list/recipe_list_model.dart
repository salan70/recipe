import 'package:flutter/material.dart';

import 'package:recipe/domain/recipe.dart';

class RecipeListModel extends ChangeNotifier {
  String toOutputIngredientText(List<Ingredient> ingredients) {
    final ingredientTextList = List.filled(ingredients.length, '');
    var outputIngredientText = '';
    var ingredientIndex = 0;

    for (final ingredient in ingredients) {
      final ingredientName = ingredient.name.toString();
      final ingredientAmount = ingredient.amount.toString();
      final ingredientUnit = ingredient.unit.toString();
      final ingredientText = '$ingredientName $ingredientAmount$ingredientUnit';
      ingredientTextList[ingredientIndex] = ingredientText;
      outputIngredientText += ingredientText;

      if (ingredientIndex + 1 < ingredients.length) {
        outputIngredientText += ', ';
      }

      ingredientIndex += 1;
    }

    return outputIngredientText;
  }
}
