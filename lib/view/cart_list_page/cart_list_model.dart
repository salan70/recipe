import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe/components/calculation/calculation.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:fraction/fraction.dart';

import '../../domain/cart.dart';

class CartListModel extends ChangeNotifier {
  List<IngredientPerInCartRecipe> createIngredientPerInCartRecipeList(
      RecipeListInCart recipe, List<Ingredient> ingredientList) {
    List<IngredientPerInCartRecipe> ingredientPerInCartRecipeList = [];

    for (var item in ingredientList) {
      Ingredient ingredient = Ingredient(
          id: item.id, name: item.name, amount: item.amount, unit: item.unit);
      IngredientPerInCartRecipe ingredientPerInCartRecipe =
          IngredientPerInCartRecipe(
              recipeId: recipe.recipeId!,
              recipeName: recipe.recipeName!,
              forHowManyPeople: recipe.forHowManyPeople!,
              countInCart: recipe.countInCart!,
              ingredient: ingredient);

      ingredientPerInCartRecipeList.add(ingredientPerInCartRecipe);
    }

    return ingredientPerInCartRecipeList;
  }

  List<IngredientInCartPerRecipeList> createIngredientListInCartPerRecipeList(
      List<IngredientPerInCartRecipe> ingredientPerInCartRecipeList) {
    Calculation calculation = Calculation();

    List<IngredientInCartPerRecipeList> ingredientListInCartPerRecipeList = [];

    // ingredientNameとingredientUnitでソート
    ingredientPerInCartRecipeList.sort((a, b) {
      int result = a.ingredient.name!.compareTo(b.ingredient.name!);
      if (result != 0) return result;
      return a.ingredient.unit!.compareTo(b.ingredient.unit!);
    });

    String previousIngredientName = '';
    String previousIngredientUnit = '';
    int returnListIndex = 0;

    for (int i = 0; i < ingredientPerInCartRecipeList.length; i++) {
      /// ingredientNameとingredientUnitが前のものと同じ場合の処理
      if (ingredientPerInCartRecipeList[i].ingredient.name == previousIngredientName &&
          ingredientPerInCartRecipeList[i].ingredient.unit ==
              previousIngredientUnit &&
          i != 0) {
        // 元々のtotalAmount
        String previousTotalAmount =
            ingredientListInCartPerRecipeList[returnListIndex - 1]
                .ingredientInCart
                .ingredientTotalAmount;

        // 新たに追加するtotalAmount
        String addTotalAmount = calculation.executeMultiply(
            ingredientPerInCartRecipeList[i].countInCart,
            ingredientPerInCartRecipeList[i].ingredient.amount);
        print(
            '------${ingredientPerInCartRecipeList[i].ingredient.name!}-----');

        // totalAmountの計算
        String totalAmount =
            calculation.executeAdd(previousTotalAmount, addTotalAmount);

        print(
            '${ingredientPerInCartRecipeList[i].ingredient.name!} $totalAmount');

        ingredientListInCartPerRecipeList[returnListIndex - 1]
            .ingredientInCart
            .ingredientTotalAmount = totalAmount;

        RecipeForIngredientInCart recipeForIngredientInCart =
            RecipeForIngredientInCart(
                recipeId: ingredientPerInCartRecipeList[i].recipeId,
                recipeName: ingredientPerInCartRecipeList[i].recipeName,
                forHowManyPeople:
                    ingredientPerInCartRecipeList[i].forHowManyPeople,
                countInCart: ingredientPerInCartRecipeList[i].countInCart,
                ingredientAmount: addTotalAmount);
        ingredientListInCartPerRecipeList[returnListIndex - 1]
            .recipeForIngredientInCartList
            .add(recipeForIngredientInCart);
      }

      /// ingredientNameとingredientUnitが前のものと異なる場合の処理
      else {
        previousIngredientName =
            ingredientPerInCartRecipeList[i].ingredient.name!;
        previousIngredientUnit =
            ingredientPerInCartRecipeList[i].ingredient.unit!;
        print(
            '------${ingredientPerInCartRecipeList[i].ingredient.name!}-----');

        String totalAmount = calculation.executeMultiply(
            ingredientPerInCartRecipeList[i].countInCart,
            ingredientPerInCartRecipeList[i].ingredient.amount);
        print(
            '${ingredientPerInCartRecipeList[i].ingredient.name!} $totalAmount');

        // ingredient系
        IngredientInCart ingredientInCart = IngredientInCart(
            ingredientName: ingredientPerInCartRecipeList[i].ingredient.name!,
            ingredientTotalAmount: totalAmount,
            ingredientUnit: ingredientPerInCartRecipeList[i].ingredient.unit!);

        // recipeList系
        List<RecipeForIngredientInCart> recipeForIngredientInCartList = [];
        RecipeForIngredientInCart recipeForIngredientInCart =
            RecipeForIngredientInCart(
                recipeId: ingredientPerInCartRecipeList[i].recipeId,
                recipeName: ingredientPerInCartRecipeList[i].recipeName,
                forHowManyPeople:
                    ingredientPerInCartRecipeList[i].forHowManyPeople,
                countInCart: ingredientPerInCartRecipeList[i].countInCart,
                ingredientAmount: totalAmount);
        recipeForIngredientInCartList.add(recipeForIngredientInCart);

        // returnするobject
        IngredientInCartPerRecipeList ingredientInCartPerInRecipeList =
            IngredientInCartPerRecipeList(
                ingredientInCart: ingredientInCart,
                recipeForIngredientInCartList: recipeForIngredientInCartList);

        ingredientListInCartPerRecipeList.add(ingredientInCartPerInRecipeList);
        returnListIndex += 1;
      }
    }

    return ingredientListInCartPerRecipeList;
  }
}
