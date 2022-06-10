import 'package:flutter/material.dart';

import 'package:recipe/components/calculation/calculation.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';
import 'package:recipe/repository/hive/cart_item_repository.dart';

class CartListModel extends ChangeNotifier {
  final _cartItemRepository = CartItemRepository();

  List<IngredientByRecipeInCart> createIngredientListByRecipeInCart(
    RecipeListInCart recipe,
  ) {
    final ingredientListByRecipeInCart = <IngredientByRecipeInCart>[];

    if (recipe.ingredientList != null) {
      for (final item in recipe.ingredientList!) {
        final ingredientByRecipeInCart = IngredientByRecipeInCart(
          recipeId: recipe.recipeId!,
          recipeName: recipe.recipeName!,
          forHowManyPeople: recipe.forHowManyPeople!,
          countInCart: recipe.countInCart!,
          ingredient: Ingredient(
            id: item.id,
            name: item.name,
            amount: item.amount,
            unit: item.unit,
          ),
        );

        ingredientListByRecipeInCart.add(ingredientByRecipeInCart);
      }
    }

    return ingredientListByRecipeInCart;
  }

  List<TotaledIngredientInCart> createTotaledIngredientListInCart(
    List<IngredientByRecipeInCart> ingredientListByRecipeInCart,
  ) {
    final calculation = Calculation();

    final totaledIngredientListInCart = <TotaledIngredientInCart>[];

    // ingredientNameとingredientUnitでソート
    ingredientListByRecipeInCart.sort((a, b) {
      final result = a.ingredient.name!.compareTo(b.ingredient.name!);
      if (result != 0) {
        return result;
      }
      return a.ingredient.unit!.compareTo(b.ingredient.unit!);
    });

    var previousIngredientName = '';
    var previousIngredientUnit = '';
    var returnListIndex = 0;

    for (var i = 0; i < ingredientListByRecipeInCart.length; i++) {
      final ingredientByRecipeInCart = ingredientListByRecipeInCart[i];

      /// ingredientNameとingredientUnitが前のものと同じ場合の処理
      if (ingredientByRecipeInCart.ingredient.name == previousIngredientName &&
          ingredientByRecipeInCart.ingredient.unit == previousIngredientUnit &&
          i != 0) {
        // 元々のtotalAmount
        final previousTotalAmount =
            totaledIngredientListInCart[returnListIndex - 1]
                .ingredientInCart
                .ingredientTotalAmount;

        // 新たに追加するtotalAmount
        final addTotalAmount = calculation.executeMultiply(
          ingredientByRecipeInCart.countInCart,
          ingredientByRecipeInCart.ingredient.amount,
        );

        // totalAmountの計算
        final totalAmount =
            calculation.executeAdd(previousTotalAmount, addTotalAmount);

        // totalAmountを更新
        totaledIngredientListInCart[returnListIndex - 1]
            .ingredientInCart
            .ingredientTotalAmount = totalAmount;

        final recipeByIngredientInCart = RecipeByIngredientInCart(
          recipeId: ingredientByRecipeInCart.recipeId,
          recipeName: ingredientByRecipeInCart.recipeName,
          forHowManyPeople: ingredientByRecipeInCart.forHowManyPeople,
          countInCart: ingredientByRecipeInCart.countInCart,
          ingredientAmount: addTotalAmount,
        );
        totaledIngredientListInCart[returnListIndex - 1]
            .recipeListByIngredientInCart
            .add(recipeByIngredientInCart);
      }

      /// ingredientNameとingredientUnitが前のものと異なる場合の処理
      else {
        previousIngredientName = ingredientByRecipeInCart.ingredient.name!;
        previousIngredientUnit = ingredientByRecipeInCart.ingredient.unit!;

        final totalAmount = calculation.executeMultiply(
          ingredientByRecipeInCart.countInCart,
          ingredientByRecipeInCart.ingredient.amount,
        );

        // ingredient系
        final ingredientInCart = IngredientInCart(
          ingredientName: ingredientByRecipeInCart.ingredient.name!,
          ingredientTotalAmount: totalAmount,
          ingredientUnit: ingredientByRecipeInCart.ingredient.unit!,
        );

        // recipeList系
        final recipeForIngredientInCartList = <RecipeByIngredientInCart>[];
        final recipeForIngredientInCart = RecipeByIngredientInCart(
          recipeId: ingredientByRecipeInCart.recipeId,
          recipeName: ingredientByRecipeInCart.recipeName,
          forHowManyPeople: ingredientByRecipeInCart.forHowManyPeople,
          countInCart: ingredientByRecipeInCart.countInCart,
          ingredientAmount: totalAmount,
        );
        recipeForIngredientInCartList.add(recipeForIngredientInCart);

        // returnするobject
        final ingredientInCartPerInRecipeList = TotaledIngredientInCart(
          ingredientInCart: ingredientInCart,
          recipeListByIngredientInCart: recipeForIngredientInCartList,
        );

        totaledIngredientListInCart.add(ingredientInCartPerInRecipeList);
        returnListIndex += 1;
      }
    }

    return totaledIngredientListInCart;
  }

  /// cart_listでの処理
  List<TotaledIngredientInCart> createBuyList(
    List<TotaledIngredientInCart> list,
  ) {
    final cartItemRepository = CartItemRepository();
    final buyList = <TotaledIngredientInCart>[];

    for (final ingredient in list) {
      final id = ingredient.ingredientInCart.ingredientName +
          ingredient.ingredientInCart.ingredientUnit;
      final cartItem = cartItemRepository.fetchItem(id);
      if (cartItem.isInBuyList == true) {
        buyList.add(ingredient);
      }
    }

    return buyList;
  }

  List<TotaledIngredientInCart> createNotBuyList(
    List<TotaledIngredientInCart> list,
  ) {
    final cartItemRepository = CartItemRepository();
    final notBuyList = <TotaledIngredientInCart>[];

    for (final ingredient in list) {
      final id = ingredient.ingredientInCart.ingredientName +
          ingredient.ingredientInCart.ingredientUnit;
      final cartItem = cartItemRepository.fetchItem(id);
      if (cartItem.isInBuyList == false) {
        notBuyList.add(ingredient);
      }
    }

    return notBuyList;
  }

  CartItem getCartItem(String id) {
    final cartItem = _cartItemRepository.fetchItem(id);
    return cartItem;
  }

  Future<void> toggleIsChecked(String id, bool isChecked) async {
    final item = _cartItemRepository.fetchItem(id);
    await _cartItemRepository.putIsChecked(item, isChecked);
  }

  Future<void> toggleIsInBuyList(String id) async {
    final item = _cartItemRepository.fetchItem(id);
    final isInBuyList = !item.isInBuyList;
    await _cartItemRepository.putIsNeed(item, isInBuyList);
  }
}
