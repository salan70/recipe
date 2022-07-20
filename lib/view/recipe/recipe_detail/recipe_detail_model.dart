import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/firebase/cart_repository.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';

class RecipeDetailModel extends ChangeNotifier {
  RecipeDetailModel({required this.user});
  final User user;
  final countList =
      List<String>.generate(99, (index) => (index + 1).toString());

  Future<String?> updateCountInCart({
    required String recipeId,
    required int countInCart,
  }) async {
    final cartRepository = CartRepository(user: user);

    try {
      final errorText = await cartRepository.updateCount(
        recipeId,
        countInCart,
      );

      if (errorText != null) {
        return errorText;
      }
    } on Exception catch (e) {
      return e.toString();
    }

    return null;
  }

  Future<bool> deleteRecipe(Recipe recipe) async {
    final recipeRepository = RecipeRepository(user: user);

    try {
      if (recipe.imageUrl != '') {
        final errorTextWhenDeleteImage =
            await recipeRepository.deleteImage(recipe);
        if (errorTextWhenDeleteImage != null) {
          return false;
        }
      }
      await recipeRepository.deleteRecipe(recipe);

      return true;
    } on Exception {
      return false;
    }
  }
}
