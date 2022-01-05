import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

var _uuid = Uuid();

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
  // Ingredient(this.ingredientIndex, this.ingredientName, this.ingredientNum);

  int? ingredientIndex;
  String? ingredientName;
  // 本来はdouble
  String? ingredientNum;
  // String? ingredientUnit;
}

class Procedure {
  Procedure({this.procedureContent, this.procedureIndex, String? id})
      : id = id ?? _uuid.v4();

  String? id;
  String? procedureContent;
  int? procedureIndex;
}

class Image {
  String? imageUrl;
}
