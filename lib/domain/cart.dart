import 'package:flutter/material.dart';

import 'package:recipe/domain/recipe.dart';

@immutable
class RecipeListInCart {
  const RecipeListInCart({
    required this.recipeId,
    required this.recipeName,
    required this.forHowManyPeople,
    required this.countInCart,
    required this.ingredientList,
  });

  final String? recipeId;
  final String? recipeName;
  final int? forHowManyPeople;
  final int? countInCart;
  final List<Ingredient>? ingredientList;

  RecipeListInCart copyWith({
    String? recipeId,
    String? recipeName,
    int? forHowManyPeople,
    int? countInCart,
    List<Ingredient>? ingredientList,
  }) {
    return RecipeListInCart(
      recipeId: recipeId ?? this.recipeId,
      recipeName: recipeName ?? this.recipeName,
      forHowManyPeople: forHowManyPeople ?? this.forHowManyPeople,
      countInCart: countInCart ?? this.countInCart,
      ingredientList: ingredientList ?? this.ingredientList,
    );
  }
}

class IngredientByRecipeInCart {
  IngredientByRecipeInCart({
    required this.recipeId,
    required this.recipeName,
    required this.forHowManyPeople,
    required this.countInCart,
    required this.ingredient,
  });

  String recipeId;
  String recipeName;
  int forHowManyPeople;
  int countInCart;
  Ingredient ingredient;
}

class TotaledIngredientInCart {
  TotaledIngredientInCart({
    required this.ingredientInCart,
    required this.recipeListByIngredientInCart,
  });

  IngredientInCart ingredientInCart;
  List<RecipeByIngredientInCart> recipeListByIngredientInCart;
}

class IngredientInCart {
  IngredientInCart({
    required this.ingredientName,
    required this.ingredientTotalAmount,
    required this.ingredientUnit,
  });

  String ingredientName;
  String ingredientTotalAmount;
  String ingredientUnit;
}

class RecipeByIngredientInCart {
  RecipeByIngredientInCart({
    required this.recipeId,
    required this.recipeName,
    required this.forHowManyPeople,
    required this.countInCart,
    required this.ingredientAmount,
  });

  String recipeId;
  String recipeName;
  int forHowManyPeople;
  int countInCart;
  String? ingredientAmount;
}
