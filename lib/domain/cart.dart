import 'package:flutter/material.dart';

import 'package:recipe/domain/recipe.dart';

@immutable
class RecipeForInCartList {
  const RecipeForInCartList(
      {required this.recipeId,
      required this.recipeName,
      required this.forHowManyPeople,
      required this.countInCart});

  final String? recipeId;
  final String? recipeName;
  final int? forHowManyPeople;
  final int? countInCart;

  RecipeForInCartList copyWith(
      {String? recipeId,
      String? recipeName,
      int? forHowManyPeople,
      int? countInCart}) {
    return RecipeForInCartList(
        recipeId: recipeId ?? this.recipeId,
        recipeName: recipeName ?? this.recipeName,
        forHowManyPeople: forHowManyPeople ?? this.forHowManyPeople,
        countInCart: countInCart ?? this.countInCart);
  }
}

class RecipeCount {
  RecipeCount({required this.id, required this.count});

  String id;
  int count;
}

class IngredientPerInCartRecipe {
  IngredientPerInCartRecipe(
      {required this.recipeId,
      required this.recipeName,
      required this.forHowManyPeople,
      required this.countInCart,
      required this.ingredient});

  String recipeId;
  String recipeName;
  int forHowManyPeople;
  int countInCart;
  Ingredient ingredient;
}

class IngredientInCartPerInRecipeList {
  IngredientInCartPerInRecipeList(
      {required this.ingredientInCart,
      required this.recipeForIngredientInCartList});

  IngredientInCart ingredientInCart;
  List<RecipeForIngredientInCart> recipeForIngredientInCartList;
}

class IngredientInCart {
  IngredientInCart(
      {required this.ingredientName,
      required this.ingredientTotalAmount,
      required this.ingredientUnit});

  String ingredientName;
  String ingredientTotalAmount;
  String ingredientUnit;
}

class RecipeForIngredientInCart {
  RecipeForIngredientInCart(
      {required this.recipeId,
      required this.recipeName,
      required this.forHowManyPeople,
      required this.countInCart,
      required this.ingredientAmount});

  String recipeId;
  String recipeName;
  int forHowManyPeople;
  int countInCart;
  String ingredientAmount;
}
