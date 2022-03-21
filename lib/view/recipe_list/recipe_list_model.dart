import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/recipe.dart';

import '../../components/providers.dart';

class RecipeListModel extends ChangeNotifier {
  // void test(WidgetRef ref){
  //   final recipes = ref.watch(recipeListStreamProvider);
  //
  //   recipes.when(data: (recipes){
  //     for(var recipe in recipes){
  //       final ingredients = ref.watch(
  //           ingredientListStreamProviderFamily(recipe.recipeId!));
  //       String outputIngredientText = '';
  //       ingredients.when(
  //           data: (ingredient) {
  //             recipe.ingredientList = ingredient;
  //
  //             outputIngredientText = toOutputIngredientText(ingredient);
  //           },
  //           error: (error, stack) => Text('Error: $error'),
  //           loading: () => const CircularProgressIndicator());
  //
  //       final procedures = ref.watch(
  //           procedureListStreamProviderFamily(recipe.recipeId!));
  //       procedures.when(
  //           data: (procedure) {
  //             recipe.procedureList = procedure;
  //           },
  //           error: (error, stack) => Text('Error: $error'),
  //           loading: () => const CircularProgressIndicator());
  //     }
  //   }, error: (error, stack) => Text('Error: $error'), loading: () => const CircularProgressIndicator());
  // }

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
