import 'package:cloud_firestore/cloud_firestore.dart';

class InCartRecipe {
  InCartRecipe(
      {required this.recipeRef,
      this.inCartRecipeId,
      this.recipeId,
      this.recipeName,
      this.forHowManyPeople,
      this.count,
      this.imageUrl});

  DocumentReference recipeRef;
  String? inCartRecipeId;
  String? recipeId;
  String? recipeName;
  int? forHowManyPeople;
  int? count;
  String? imageUrl;
}
