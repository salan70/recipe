import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';

class RecipeDetailModel extends ChangeNotifier {
  RecipeDetailModel({required this.user});
  final User user;

  Future<bool> deleteRecipe(Recipe recipe) async {
    final recipeRepository = RecipeRepository(user: user);

    try {
      if (recipe.imageUrl != '') {
        await recipeRepository.deleteImage(recipe);
      }
      await recipeRepository.deleteRecipe(recipe);

      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}
