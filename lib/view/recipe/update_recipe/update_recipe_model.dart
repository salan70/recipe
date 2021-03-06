import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';

class UpdateRecipeModel extends ChangeNotifier {
  UpdateRecipeModel({required this.user});
  final User user;

  Future<bool> updateRecipe(Recipe originalRecipe, Recipe recipe) async {
    final recipeRepository = RecipeRepository(user: user);

    final ingredientListMap = _ingredientMapToList(recipe.ingredientList);
    final procedureListMap = _procedureMapToList(recipe.procedureList);

    try {
      await recipeRepository.updateRecipe(
        originalRecipe.recipeId!,
        recipe,
        ingredientListMap,
        procedureListMap,
      );
      if (await _updateImage(originalRecipe, recipe)) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }

  Map<String, dynamic> _ingredientToMap(Ingredient ingredient) {
    return <String, dynamic>{
      'ingredientName': ingredient.name,
      'ingredientSymbol': ingredient.symbol,
      'ingredientAmount': ingredient.amount,
      'ingredientUnit': ingredient.unit
    };
  }

  Map<String, Map<String, dynamic>> _ingredientMapToList(
    List<Ingredient>? ingredientList,
  ) {
    final ingredientListMap = <String, Map<String, dynamic>>{};

    if (ingredientList != null) {
      for (var index = 0; index < ingredientList.length; index++) {
        if (ingredientList[index].name != '') {
          ingredientListMap[index.toString()] =
              _ingredientToMap(ingredientList[index]);
        }
      }
    }
    return ingredientListMap;
  }

  Map<String, dynamic> _procedureToMap(Procedure procedure) {
    return <String, dynamic>{
      'content': procedure.content,
    };
  }

  Map<String, Map<String, dynamic>> _procedureMapToList(
    List<Procedure>? procedureList,
  ) {
    final procedureListMap = <String, Map<String, dynamic>>{};

    if (procedureList != null) {
      for (var index = 0; index < procedureList.length; index++) {
        if (procedureList[index].content != '') {
          procedureListMap[index.toString()] =
              _procedureToMap(procedureList[index]);
        }
      }
    }
    return procedureListMap;
  }

  Future<bool> _updateImage(Recipe originalRecipe, Recipe recipe) async {
    final recipeRepository = RecipeRepository(user: user);

    // ????????????????????? & ???????????????????????????????????????????????????????????????????????????????????????
    if (recipe.imageFile == null || recipe.imageFile!.path == '') {
      return true;
    } else {
      if (originalRecipe.imageUrl != '') {
        final errorTextWhenDeleteImage =
            await recipeRepository.deleteImage(originalRecipe);
        if (errorTextWhenDeleteImage != null) {
          return false;
        }
      }
      await recipeRepository.addImage(
        recipe.imageFile!,
        originalRecipe.recipeId!,
      );
    }
    return true;
  }
}
