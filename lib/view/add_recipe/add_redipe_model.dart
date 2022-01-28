import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/recipe.dart';

class AddRecipeModel extends ChangeNotifier {
  String? recipeName;
  double? recipeGrade;
  String? recipeMemo;
  String? recipeImageURL;

  Future addRecipe(Recipe recipe, List<Ingredient> ingredientList,
      List<Procedure> procedureList) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('testCollection').add({
      'recipeName': recipe.recipeName,
      'recipeGrade': recipe.recipeGrade,
      'recipeMemo': recipe.recipeMemo
    });
    print(docRef.id);

    // 材料を保存
    for (int i = 0; i < ingredientList.length; i++) {
      await FirebaseFirestore.instance
          .collection('testCollection')
          .doc(docRef.id)
          .collection('ingredient')
          .doc()
          .set({
        'id': ingredientList[i].id,
        'name': ingredientList[i].name,
        'amount': ingredientList[i].amount,
        'unit': ingredientList[i].unit,
        'orderNum': i,
      });
    }

    // 手順を保存
    for (int i = 0; i < procedureList.length; i++) {
      await FirebaseFirestore.instance
          .collection('testCollection')
          .doc(docRef.id)
          .collection('procedure')
          .doc()
          .set({
        'id': procedureList[i].id,
        'content': procedureList[i].content,
        'orderNum': i
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
