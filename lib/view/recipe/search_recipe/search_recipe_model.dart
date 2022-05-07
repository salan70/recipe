import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe/domain/recipe.dart';

class SearchRecipeModel extends ChangeNotifier {
  String toOutputIngredientText(List<Ingredient> ingredients) {
    final List<String> ingredientTextList = List.filled(ingredients.length, '');
    String outputIngredientText = '';
    int ingredientIndex = 0;

    for (var ingredient in ingredients) {
      String ingredientName = ingredient.name.toString();
      String ingredientAmount = ingredient.amount.toString();
      String ingredientUnit = ingredient.unit.toString();
      String ingredientText =
          ingredientName + ' ' + ingredientAmount + ingredientUnit;
      ingredientTextList[ingredientIndex] = ingredientText;
      // print(ingredientTextList[index]);
      outputIngredientText += ingredientText;

      if (ingredientIndex + 1 < ingredients.length) {
        outputIngredientText += ', ';
      }

      ingredientIndex += 1;
    }

    return outputIngredientText;
  }
}
