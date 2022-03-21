import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/recipe_repository.dart';

class AddRecipeModel extends ChangeNotifier {
  AddRecipeModel({required this.user});
  final User user;

  Future addRecipe(Recipe recipe) async {
    RecipeRepository _recipeRepository = RecipeRepository(user: user);
    await _recipeRepository.addRecipe(recipe);
  }
}
