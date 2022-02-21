import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:recipe/domain/recipe.dart';

class RecipeRepository {
  RecipeRepository(this.user);

  final User user;

  Stream<List<Recipe>> getRecipeList() {
    return FirebaseFirestore.instance
        .collection('users/${user.uid}/recipes')
        .snapshots()
        .map(_queryToRecipeList);
  }

  List<Recipe> _queryToRecipeList(QuerySnapshot query) {
    final List<Ingredient>? ingredientList;
    final List<Procedure>? procedureList;

    return query.docs.map((doc) {
      final recipeId = doc.id;

      return Recipe(
          recipeName: doc.get('recipeName'),
          recipeGrade: doc.get('recipeName'),
          forHowManyPeople: doc.get('recipeName'),
          recipeMemo: doc.get('recipeName'),
          imageUrl: doc.get('recipeName'),
          imageFile: doc.get('recipeName'),
          ingredientList: doc.get('recipeName'),
          procedureList: doc.get('recipeName'));
    }).toList();
  }

  Stream<List<Ingredient>> getIngredientList(String recipeId) {
    return FirebaseFirestore.instance
        .collection('users/${user.uid}/recipes/$recipeId/ingredient')
        .snapshots()
        .map(_queryToIngredientList);
  }

  List<Ingredient> _queryToIngredientList(QuerySnapshot query) {
    return query.docs.map((doc) {
      return Ingredient(
          id: doc.get('recipeName'),
          name: doc.get('recipeName'),
          amount: doc.get('recipeName'),
          unit: doc.get('recipeName'));
    }).toList();
  }
}
