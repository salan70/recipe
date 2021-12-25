import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/recipe.dart';

class AddRecipeModel extends ChangeNotifier {
  String? recipeName;
  double? recipeGrade;
  List<Ingredient>? recipeIngredient;
  List<Procedure>? recipeProcedure;
  String? recipeMemo;
  String? recipeImageURL;

  Future addRecipe(Recipe recipe) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('testCollection').add({
      'recipeName': recipe.recipeName,
      'recipeGrade': recipe.recipeGrade,
      'recipeMemo': recipe.recipeMemo
    });
    print(docRef.id);
    // // 追加の処理
    // await FirebaseFirestore.instance
    //     .collection('testCollection')
    //     .doc(docRef.id)
    //     .collection('ingredients')
    //     .doc()
    //     .set({'name': "パセリ", 'num': "500", 'No': "1"});
  }
}

class RecipeListNotifier extends StateNotifier<List<Recipe>> {
  RecipeListNotifier() : super([]);

  void add(Recipe recipe) {
    state = [...state, recipe];
  }
}

class IngredientListNotifier extends StateNotifier<List<Ingredient>> {
  IngredientListNotifier() : super([]);

  void add(Ingredient ingredient) {
    state = [...state, ingredient];
  }
}
