import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';

class AddRecipeModel extends ChangeNotifier {
  AddRecipeModel({required this.user});
  final User user;

  Future<bool> addRecipe(Recipe recipe) async {
    RecipeRepository _recipeRepository = RecipeRepository(user: user);
    bool addIsSuccess = false;

    try {
      DocumentReference docRef = await _recipeRepository.addRecipe(recipe);
      String recipeId = docRef.id;

      if (recipe.imageFile != null) {
        if (recipe.imageFile!.path != '') {
          await _recipeRepository.addImage(recipe.imageFile!, recipeId);
        }
      }

      if (recipe.ingredientList != null) {
        await _recipeRepository.addIngredient(recipe.ingredientList!, recipeId);
      }
      if (recipe.procedureList != null) {
        await _recipeRepository.addProcedure(recipe.procedureList!, recipeId);
      }
      addIsSuccess = true;
    } catch (e) {
      print(e);
    }
    return addIsSuccess;
  }
}
