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
    bool deleteIsSuccess = false;
    RecipeRepository _recipeRepository = RecipeRepository(user: user);

    try {
      await _recipeRepository.deleteProcedures(recipe.recipeId!);
      await _recipeRepository.deleteIngredients(recipe.recipeId!);
      if (recipe.imageUrl != '') {
        print('delete image: ${recipe.imageUrl}');
        await _recipeRepository.deleteImage(recipe);
      }
      await _recipeRepository.deleteRecipe(recipe);
      print('delete:' + recipe.recipeId!);

      deleteIsSuccess = true;
    } catch (e) {
      print(e);
    }

    return deleteIsSuccess;
  }
}
