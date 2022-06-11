import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/firebase/recipe_repository.dart';

class AddRecipeModel extends ChangeNotifier {
  AddRecipeModel({required this.user});
  final User user;

  Future<bool> addRecipe(Recipe recipe) async {
    final recipeRepository = RecipeRepository(user: user);

    final ingredientListMap = _ingredientMapToList(recipe.ingredientList);
    final procedureListMap = _procedureMapToList(recipe.procedureList);

    try {
      final docRef = await recipeRepository.addRecipe(
        recipe,
        ingredientListMap,
        procedureListMap,
      );
      final recipeId = docRef.id;
      await _addImage(recipe, recipeId);

      return true;
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

  Future<void> _addImage(Recipe recipe, String recipeId) async {
    final recipeRepository = RecipeRepository(user: user);

    if (recipe.imageFile == null || recipe.imageFile!.path == '') {
    } else {
      await recipeRepository.addImage(recipe.imageFile!, recipeId);
    }
  }
}
