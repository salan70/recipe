import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  Recipe(
    // this.recipeId,
    this.recipeName,
    this.recipeGrade,
    // this.recipeIngredient,
    // this.recipeProcedure,
    this.recipeMemo,
    // this.recipeImage
  );

  // String? recipeId;
  String? recipeName;
  double? recipeGrade;
  // List<Ingredient>? recipeIngredient;
  // List<Procedure>? recipeProcedure;
  String? recipeMemo;
  // Image? recipeImage;
}

class Ingredient {
  Ingredient(this.ingredientIndex, this.ingredientName, this.ingredientNum);

  int? ingredientIndex;
  String? ingredientName;
  double? ingredientNum;
  // String? ingredientUnit;
}

class Procedure {
  Procedure(this.procedureContent, this.procedureIndex);

  String? procedureContent;
  int? procedureIndex;
}

class Image {
  String? imageUrl;
}
