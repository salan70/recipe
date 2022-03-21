import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InCartRecipe {
  InCartRecipe(
      {this.recipeRef,
      this.inCartRecipeId,
      this.recipeId,
      this.recipeName,
      this.forHowManyPeople,
      this.count,
      this.imageUrl});

  DocumentReference? recipeRef;
  String? inCartRecipeId;
  String? recipeId;
  String? recipeName;
  int? forHowManyPeople;
  int? count;
  String? imageUrl;
}

class RecipeCount {
  RecipeCount({required this.id, required this.count});

  String id;
  int count;
}
