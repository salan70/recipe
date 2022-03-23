import 'package:flutter/material.dart';

@immutable
class RecipeForInCartList {
  const RecipeForInCartList(
      {required this.recipeId,
      required this.recipeName,
      required this.forHowManyPeople,
      required this.countInCart});

  final String? recipeId;
  final String? recipeName;
  final int? forHowManyPeople;
  final int? countInCart;

  RecipeForInCartList copyWith(
      {String? recipeId,
      String? recipeName,
      int? forHowManyPeople,
      int? countInCart}) {
    return RecipeForInCartList(
        recipeId: recipeId ?? this.recipeId,
        recipeName: recipeName ?? this.recipeName,
        forHowManyPeople: forHowManyPeople ?? this.forHowManyPeople,
        countInCart: countInCart ?? this.countInCart);
  }
}

class RecipeCount {
  RecipeCount({required this.id, required this.count});

  String id;
  int count;
}
