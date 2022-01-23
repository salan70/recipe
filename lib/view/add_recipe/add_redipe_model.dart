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

  Future addRecipe(Recipe recipe, List<Procedure> proceduresList) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('testCollection').add({
      'recipeName': recipe.recipeName,
      'recipeGrade': recipe.recipeGrade,
      'recipeMemo': recipe.recipeMemo
    });
    print(docRef.id);
    // 手順を保存
    for (int i = 0; i < proceduresList.length; i++) {
      await FirebaseFirestore.instance
          .collection('testCollection')
          .doc(docRef.id)
          .collection('procedures')
          .doc()
          .set({
        'id': proceduresList[i].id,
        'content': proceduresList[i].content,
        'num': i
      });
    }
  }
}

class RecipeListNotifier extends StateNotifier<List<Recipe>> {
  RecipeListNotifier() : super([]);

  void add(Recipe recipe) {
    state = [...state, recipe];
  }
}
