import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

class ImageFile {
  ImageFile(this.imageFile);

  final File? imageFile;
}

class Recipe {
  Recipe(
      {this.recipeId,
      this.recipeName,
      this.recipeGrade,
      this.forHowManyPeople,
      this.recipeMemo,
      this.imageUrl,
      this.imageFile,
      this.ingredientList,
      this.procedureList});

  final String? recipeId;
  final String? recipeName;
  final double? recipeGrade;
  final int? forHowManyPeople;
  final String? recipeMemo;
  final String? imageUrl;
  final File? imageFile;
  final List<Ingredient>? ingredientList;
  final List<Procedure>? procedureList;
}

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String id,
    String? name,
    String? amount,
    String? unit,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}

class Procedure {
  Procedure(this.id, this.content);

  final String id;
  final String content;
}
