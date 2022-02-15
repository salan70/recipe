import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

class Recipe {
  Recipe(
      // this.recipeId,
      this.recipeName,
      this.recipeGrade,
      this.forHowManyPeople,
      // this.recipeIngredient,
      // this.recipeProcedure,
      this.recipeMemo,
      this.recipeImage);

  // String? recipeId;
  String? recipeName;
  double? recipeGrade;
  int? forHowManyPeople;
  // List<Ingredient>? recipeIngredient;
  // List<Procedure>? recipeProcedure;
  String? recipeMemo;
  File? recipeImage;
}

// class Ingredient {
//   Ingredient(this.id, this.name, this.amount, this.unit);
//
//   String id;
//   String name;
//   double amount;
//   String unit;
// }

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String id,
    required String name,
    required String amount,
    required String unit,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}

class Procedure {
  Procedure(this.id, this.content);

  final String id;
  final String content;
}

class ImageFile {
  ImageFile(this.imageFile);

  File? imageFile;
}
