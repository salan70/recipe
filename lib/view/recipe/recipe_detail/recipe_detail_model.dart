import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/recipe.dart';

import '../../../repository/firebase/recipe_repository.dart';

class RecipeDetailModel extends ChangeNotifier {
  RecipeDetailModel({required this.user});
  final User user;

  Future<bool> deleteRecipe(Recipe recipe) async {
    RecipeRepository _recipeRepository = RecipeRepository(user: user);

    try {
      if (recipe.imageUrl != '') {
        await _recipeRepository.deleteImage(recipe);
      }
      await _recipeRepository.deleteRecipe(recipe);

      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }
}
