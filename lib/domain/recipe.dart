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

class Procedures {
  Procedures(this.id, this.content);

  final int id;
  final String content;
}

class Image {
  String? imageUrl;
}
