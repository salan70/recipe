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
      await _updateImage(originalRecipe, recipe);

      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Map<String, dynamic> _ingredientToMap(Ingredient ingredient) {
    return <String, dynamic>{
      'ingredientName': ingredient.name,
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

  Future<void> _updateImage(Recipe originalRecipe, Recipe recipe) async {
    final recipeRepository = RecipeRepository(user: user);

    // 元の画像がある & 画像を変更する場合、元の画像を削除して新たに画像を保存する
    if (recipe.imageFile == null || recipe.imageFile!.path == '') {
    } else {
      if (originalRecipe.imageUrl != '') {
        await recipeRepository.deleteImage(originalRecipe);
      }
      await recipeRepository.addImage(
        recipe.imageFile!,
        originalRecipe.recipeId!,
      );
    }
  }
}
