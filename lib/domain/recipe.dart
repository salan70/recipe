import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

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

  String? recipeId;
  String? recipeName;
  double? recipeGrade;
  int? forHowManyPeople;
  String? recipeMemo;
  String? imageUrl;
  File? imageFile;
  List<Ingredient>? ingredientList;
  List<Procedure>? procedureList;
}

// @freezed
// class Ingredient with _$Ingredient {
//   const factory Ingredient({
//     required String id,
//     String? name,
//     String? amount,
//     String? unit,
//   }) = _Ingredient;
//
//   factory Ingredient.fromJson(Map<String, dynamic> json) =>
//       _$IngredientFromJson(json);
// }

@immutable
class Ingredient {
  const Ingredient(
      {required this.id,
      required this.name,
      required this.amount,
      required this.unit});

  final String id;
  final String? name;
  final String? amount;
  final String? unit;

  Ingredient copyWith(
      {String? id, String? name, String? amount, String? unit}) {
    return Ingredient(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit);
  }
}

class Procedure {
  Procedure({this.id, this.content});

  final String? id;
  final String? content;
}
