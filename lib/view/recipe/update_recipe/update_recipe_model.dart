import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';

class UpdateRecipeModel extends ChangeNotifier {
  UpdateRecipeModel({required this.user});
  final User user;

  Future<bool> updateRecipe(Recipe originalRecipe, Recipe recipe) async {
    RecipeRepository _recipeRepository = RecipeRepository(user: user);

    bool updateIsSuccess = false;

    try {
      // 元の画像がある & 画像を変更する場合、元の画像を削除して新たに画像を保存する
      if (recipe.imageFile != null) {
        if (recipe.imageFile!.path != '') {
          if (originalRecipe.imageUrl != '') {
            await _recipeRepository.deleteImage(originalRecipe);
          }
          await _recipeRepository.addImage(
              recipe.imageFile!, originalRecipe.recipeId!);
        }
      }

      await _recipeRepository.updateRecipe(originalRecipe.recipeId!, recipe);
      if (recipe.ingredientList != null) {
        await _recipeRepository.deleteIngredients(originalRecipe.recipeId!);
        await _recipeRepository.addIngredient(
            recipe.ingredientList!, originalRecipe.recipeId!);
      }
      if (recipe.procedureList != null) {
        await _recipeRepository.deleteProcedures(originalRecipe.recipeId!);
        await _recipeRepository.addProcedure(
            recipe.procedureList!, originalRecipe.recipeId!);
      }
      updateIsSuccess = true;
    } catch (e) {
      print(e);
    }

    return updateIsSuccess;
  }
}
