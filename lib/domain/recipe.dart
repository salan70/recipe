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
  Ingredient(this.id, this.name, this.amount, this.unit);

  String id;
  String name;
  double amount;
  String unit;
}

class Procedure {
  Procedure(this.id, this.content);

  final String id;
  final String content;
}

class Image {
  String? imageUrl;
}
