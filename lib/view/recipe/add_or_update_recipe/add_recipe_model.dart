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

    try {
      DocumentReference docRef = await _recipeRepository.addRecipe(recipe);
      String recipeId = docRef.id;
      await _addImage(recipe, recipeId);
      await _addIngredientList(recipe, recipeId);
      await _addProcedureList(recipe, recipeId);

      return true;
    } catch (e) {
      print('error $e');
      return false;
    }
  }

  Future _addImage(Recipe recipe, String recipeId) async {
    RecipeRepository _recipeRepository = RecipeRepository(user: user);

    if (recipe.imageFile == null || recipe.imageFile!.path == '') {
      print('imageFile is Null or empty');
    } else {
      print(recipe.imageFile);
      await _recipeRepository.addImage(recipe.imageFile!, recipeId);
    }
  }

  Future _addIngredientList(Recipe recipe, String recipeId) async {
    RecipeRepository _recipeRepository = RecipeRepository(user: user);

    if (recipe.ingredientList != null) {
      await _recipeRepository.addIngredient(recipe.ingredientList!, recipeId);
    }
  }

  Future _addProcedureList(Recipe recipe, String recipeId) async {
    RecipeRepository _recipeRepository = RecipeRepository(user: user);

    if (recipe.procedureList != null) {
      await _recipeRepository.addProcedure(recipe.procedureList!, recipeId);
    }
  }
}
