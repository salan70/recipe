import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/recipe_repository.dart';

class UpdateRecipeModel extends ChangeNotifier {
  UpdateRecipeModel({required this.user});
  final User user;

  Future updateRecipe(String originalRecipeId, Recipe recipe) async {
    RecipeRepository _recipeRepository = RecipeRepository(user: user);
    await _recipeRepository.updateRecipe(originalRecipeId, recipe);
  }
}
