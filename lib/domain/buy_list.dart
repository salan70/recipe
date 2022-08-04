import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recipe/domain/recipe.dart';

part 'buy_list.freezed.dart';

@freezed
class OtherBuyListItem with _$OtherBuyListItem {
  const factory OtherBuyListItem({
    String? itemId,
    DateTime? createdAt,
    required String title,
    required String subTitle,
  }) = _OtherBuyListItem;
}

@immutable
class RecipeInCart {
  const RecipeInCart({
    required this.recipeId,
    required this.recipeName,
    required this.imageUrl,
    required this.forHowManyPeople,
    required this.countInCart,
    required this.ingredientList,
  });

  final String? recipeId;
  final String? recipeName;
  final String? imageUrl;
  final int? forHowManyPeople;
  final int? countInCart;
  final List<Ingredient>? ingredientList;

  RecipeInCart copyWith({
    String? recipeId,
    String? recipeName,
    String? imageUrl,
    int? forHowManyPeople,
    int? countInCart,
    List<Ingredient>? ingredientList,
  }) {
    return RecipeInCart(
      recipeId: recipeId ?? this.recipeId,
      recipeName: recipeName ?? this.recipeName,
      imageUrl: imageUrl ?? this.imageUrl,
      forHowManyPeople: forHowManyPeople ?? this.forHowManyPeople,
      countInCart: countInCart ?? this.countInCart,
      ingredientList: ingredientList ?? this.ingredientList,
    );
  }
}

class IngredientByRecipeInCart {
  IngredientByRecipeInCart({
    required this.recipeId,
    required this.recipeName,
    required this.forHowManyPeople,
    required this.countInCart,
    required this.ingredient,
  });

  String recipeId;
  String recipeName;
  int forHowManyPeople;
  int countInCart;
  Ingredient ingredient;
}

class TotaledIngredientInCart {
  TotaledIngredientInCart({
    required this.ingredientInCart,
    required this.recipeListByIngredientInCart,
  });

  IngredientInCart ingredientInCart;
  List<RecipeByIngredientInCart> recipeListByIngredientInCart;
}

class IngredientInCart {
  IngredientInCart({
    required this.ingredientName,
    required this.ingredientTotalAmount,
    required this.ingredientUnit,
  });

  String ingredientName;
  String ingredientTotalAmount;
  String ingredientUnit;
}

class RecipeByIngredientInCart {
  RecipeByIngredientInCart({
    required this.recipeId,
    required this.recipeName,
    required this.forHowManyPeople,
    required this.countInCart,
    required this.ingredientAmount,
  });

  String recipeId;
  String recipeName;
  int forHowManyPeople;
  int countInCart;
  String? ingredientAmount;
}
