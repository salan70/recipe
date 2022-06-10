import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';

class UpdateRecipeModel extends ChangeNotifier {
  UpdateRecipeModel({required this.user});
  final User user;

  Future<bool> updateRecipe(Recipe originalRecipe, Recipe recipe) async {
    RecipeRepository _recipeRepository = RecipeRepository(user: user);

    Map<String, Map<String, dynamic>>? ingredientListMap =
        _ingredientMapToList(recipe.ingredientList);
    Map<String, Map<String, dynamic>>? procedureListMap =
        _procedureMapToList(recipe.procedureList);

    try {
      await _recipeRepository.updateRecipe(originalRecipe.recipeId!, recipe,
          ingredientListMap, procedureListMap);
      await _updateImage(originalRecipe, recipe);

      return true;
    } catch (e) {
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
      List<Ingredient>? ingredientList) {
    Map<String, Map<String, dynamic>> ingredientListMap = {};

    if (ingredientList != null) {
      for (int index = 0; index < ingredientList.length; index++) {
        if (ingredientList[index].name != '') {
          print('$index: ${ingredientList[index].name}');
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
      List<Procedure>? procedureList) {
    Map<String, Map<String, dynamic>> procedureListMap = {};

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
      print('imageFile is Null or empty');
    } else {
      if (originalRecipe.imageUrl != '') {
        await recipeRepository.deleteImage(originalRecipe);
      }
      await recipeRepository.addImage(
          recipe.imageFile!, originalRecipe.recipeId!);
    }
  }
}
