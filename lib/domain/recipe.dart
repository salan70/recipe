import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

class Recipe {
  Recipe(
      {this.recipeId,
      this.recipeName,
      this.recipeGrade,
      this.forHowManyPeople,
      this.countInCart,
      this.recipeMemo,
      this.imageUrl,
      this.imageFile,
      this.ingredientList,
      this.procedureList});

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
class RecipeStream {
  const RecipeStream(
      {required this.recipeId,
      required this.recipeName,
      required this.recipeGrade,
      required this.forHowManyPeople,
      required this.recipeMemo,
      required this.imageUrl,
      required this.ingredientList,
      required this.procedureList});

  final String? recipeId;
  final String? recipeName;
  final double? recipeGrade;
  final int? forHowManyPeople;
  final String? recipeMemo;
  final String? imageUrl;
  final List<Ingredient>? ingredientList;
  final List<Procedure>? procedureList;

  RecipeStream copyWith({
    String? recipeId,
    String? recipeName,
    double? recipeGrade,
    int? forHowManyPeople,
    String? recipeMemo,
    String? imageUrl,
    List<Ingredient>? ingredientList,
    List<Procedure>? procedureList,
  }) {
    return RecipeStream(
        recipeId: recipeId ?? this.recipeId,
        recipeName: recipeName ?? this.recipeName,
        recipeGrade: recipeGrade ?? this.recipeGrade,
        forHowManyPeople: forHowManyPeople ?? this.forHowManyPeople,
        recipeMemo: recipeMemo ?? this.recipeMemo,
        imageUrl: imageUrl ?? this.imageUrl,
        ingredientList: ingredientList ?? this.ingredientList,
        procedureList: procedureList ?? this.procedureList);
  }
}

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

@immutable
class Procedure {
  Procedure({required this.id, required this.content});

  final String? id;
  final String? content;

  Procedure copyWith({String? id, String? content}) {
    return Procedure(id: id ?? this.id, content: content ?? this.content);
  }
}
