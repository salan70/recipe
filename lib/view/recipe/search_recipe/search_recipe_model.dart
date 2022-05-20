import 'package:flutter/material.dart';

import 'package:recipe/domain/recipe.dart';

class SearchRecipeModel extends ChangeNotifier {
  List<String> searchRecipe(String searchWord,
      List<RecipeAndIngredientName> recipeAndIngredientNameList) {
    final searchWordList = _searchWordToList(searchWord);
    List<String> searchResultList = [];

    // searchWordListが空の場合、全レシピを出力
    if (searchWordList.isEmpty == true) {
      for (var recipeAndIngredientName in recipeAndIngredientNameList) {
        searchResultList.add(recipeAndIngredientName.recipeId);
      }
    }
    // searchWordListが空でない場合の処理
    else {
      for (var recipeAndIngredientName in recipeAndIngredientNameList) {
        if (_searchWordListFoundInRecipeAndIngredientName(
                searchWordList, recipeAndIngredientName) ==
            true) {
          searchResultList.add(recipeAndIngredientName.recipeId);
        }
      }
    }
    return searchResultList;
  }

  bool _searchWordListFoundInRecipeAndIngredientName(
      List<String> searchWordList,
      RecipeAndIngredientName recipeAndIngredientName) {
    for (var searchWord in searchWordList) {
      if (!_searchWordFoundInRecipeAndIngredientName(
          searchWord, recipeAndIngredientName)) {
        return false;
      }
    }
    return true;
  }

  bool _searchWordFoundInRecipeAndIngredientName(
      String searchWord, RecipeAndIngredientName recipeAndIngredientName) {
    if (recipeAndIngredientName.recipeName.contains(searchWord)) {
      return true;
    } else {
      if (_searchWordFoundInStringList(
          searchWord, recipeAndIngredientName.ingredientNameList)) {
        return true;
      }
    }
    return false;
  }

  bool _searchWordFoundInStringList(String searchWord, List<String> list) {
    for (var item in list) {
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
