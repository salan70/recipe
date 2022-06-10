import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class Recipe {
  Recipe({
    this.recipeId,
    this.recipeName,
    this.recipeGrade,
    this.forHowManyPeople,
    this.countInCart,
    this.recipeMemo,
    this.imageUrl,
    this.imageFile,
    this.ingredientList,
    this.procedureList,
  });

  String? recipeId;
  String? recipeName;
  double? recipeGrade;
  int? forHowManyPeople;
  int? countInCart;
  String? recipeMemo;
  String? imageUrl;
  File? imageFile;
  List<Ingredient>? ingredientList;
  List<Procedure>? procedureList;
}

@immutable
class Ingredient {
  const Ingredient({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
  });

  final String id;
  final String? name;
  final String? amount;
  final String? unit;

  Ingredient copyWith({
    String? id,
    String? name,
    String? amount,
    String? unit,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
    );
  }
}

@immutable
class Procedure {
  const Procedure({required this.id, required this.content});

  final String? id;
  final String? content;

  Procedure copyWith({String? id, String? content}) {
    return Procedure(id: id ?? this.id, content: content ?? this.content);
  }
}

class RecipeAndIngredientName {
  RecipeAndIngredientName({
    required this.recipeId,
    required this.recipeName,
    required this.ingredientNameList,
  });

  String recipeId;
  String recipeName;
  List<String> ingredientNameList;
}
