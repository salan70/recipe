import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/recipe_repository.dart';

import '../../domain/cart.dart';

class CartListModel extends ChangeNotifier {
  CartListModel({required this.user});
  final User user;

  List<IngredientPerInCartRecipe> createIngredientPerInCartRecipeList(
      Recipe recipe, List<Ingredient> ingredientList) {
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

  // List<IngredientInCartPerInRecipeList>
  //     createIngredientListInCartPerInRecipeList(
  //         List<IngredientPerInCartRecipe> ingredientPerInCartRecipeList) {
  //   List<IngredientInCartPerInRecipeList> ingredientListInCartPerInRecipeList =
  //       [];
  //
  //   for (var item in ingredientPerInCartRecipeList) {
  //     IngredientInCart ingredientInCart = IngredientInCart(
  //         ingredientName: item.ingredient.name!,
  //         ingredientTotalAmount: ingredientTotalAmount,
  //         ingredientUnit: ingredientUnit);
  //     List<RecipeForIngredientInCart> recipeForIngredientInCartList = [];
  //     IngredientInCartPerInRecipeList ingredientInCartPerInRecipeList =
  //         IngredientInCartPerInRecipeList(
  //             ingredientInCart: ingredientInCart,
  //             recipeForIngredientInCartList: recipeForIngredientInCartList);
  //
  //     ingredientPerInCartRecipeList.add(ingredientPerInCartRecipe);
  //   }
  //
  //   return ingredientPerInCartRecipeList;
  // }
}
