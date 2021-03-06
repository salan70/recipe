import 'package:flutter/material.dart';
import 'package:recipe/domain/recipe.dart';

class SearchRecipeModel extends ChangeNotifier {
  List<String> searchRecipe(
    String searchWord,
    List<RecipeAndIngredient> recipeAndIngredientNameList,
  ) {
    final searchWordList = _searchWordToList(searchWord);
    final searchResultList = <String>[];

    for (final recipeAndIngredientName in recipeAndIngredientNameList) {
      if (_searchWordListFoundInRecipeAndIngredientName(
        searchWordList,
        recipeAndIngredientName,
      )) {
        searchResultList.add(recipeAndIngredientName.recipeId);
      }
    }
    // }
    return searchResultList;
  }

  bool _searchWordListFoundInRecipeAndIngredientName(
    List<String> searchWordList,
    RecipeAndIngredient recipeAndIngredientName,
  ) {
    for (final searchWord in searchWordList) {
      if (!_searchWordFoundInRecipeAndIngredientName(
        searchWord,
        recipeAndIngredientName,
      )) {
        return false;
      }
    }
    return true;
  }

  bool _searchWordFoundInRecipeAndIngredientName(
    String searchWord,
    RecipeAndIngredient recipeAndIngredientName,
  ) {
    if (recipeAndIngredientName.recipeName.contains(searchWord)) {
      return true;
    } else {
      if (_searchWordFoundInStringList(
        searchWord,
        recipeAndIngredientName.ingredientNameList,
      )) {
        return true;
      }
    }
    return false;
  }

  bool _searchWordFoundInStringList(String searchWord, List<String> list) {
    for (final item in list) {
      if (item.contains(searchWord)) {
        return true;
      }
    }
    return false;
  }

  List<String> _searchWordToList(String searchWord) {
    return searchWord.split(' ');
  }
}
