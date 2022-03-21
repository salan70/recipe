import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/recipe_repository.dart';

class AddRecipeModel extends ChangeNotifier {
  AddRecipeModel({required this.user});
  final User user;

  Future<bool> addRecipe(Recipe recipe, File imageFile) async {
    RecipeRepository _recipeRepository = RecipeRepository(user: user);
    bool addIsSuccess = false;

    try {
      DocumentReference docRef = await _recipeRepository.addRecipe(recipe);

      if (imageFile.path != '') {
        await _recipeRepository.addImage(imageFile, docRef.id);
      }

      if (recipe.ingredientList != null) {
        await _recipeRepository.addIngredient(recipe.ingredientList!, docRef);
      }
      if (recipe.procedureList != null) {
        await _recipeRepository.addProcedure(recipe.procedureList!, docRef);
      }
      addIsSuccess = true;
    } catch (e) {
      print(e);
    }
    return addIsSuccess;
  }
}
