import 'package:flutter/material.dart';

import 'package:recipe/components/calculation/calculation.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';
import 'package:recipe/repository/hive/cart_item_repository.dart';

class CartListModel extends ChangeNotifier {
  CartItemRepository _cartItemRepository = CartItemRepository();

  List<IngredientByRecipeInCart> createIngredientListByRecipeInCart(
      RecipeListInCart recipe) {
    List<IngredientByRecipeInCart> ingredientListByRecipeInCart = [];

    if (recipe.ingredientList != null) {
      for (var item in recipe.ingredientList!) {
        IngredientByRecipeInCart ingredientByRecipeInCart =
            IngredientByRecipeInCart(
                recipeId: recipe.recipeId!,
                recipeName: recipe.recipeName!,
                forHowManyPeople: recipe.forHowManyPeople!,
                countInCart: recipe.countInCart!,
                ingredient: Ingredient(
                    id: item.id,
                    name: item.name,
                    amount: item.amount,
                    unit: item.unit));

        ingredientListByRecipeInCart.add(ingredientByRecipeInCart);
      }
    }

    return ingredientListByRecipeInCart;
  }

  List<TotaledIngredientInCart> createTotaledIngredientListInCart(
      List<IngredientByRecipeInCart> ingredientListByRecipeInCart) {
    Calculation calculation = Calculation();

    List<TotaledIngredientInCart> totaledIngredientListInCart = [];

    // ingredientNameとingredientUnitでソート
    ingredientListByRecipeInCart.sort((a, b) {
      int result = a.ingredient.name!.compareTo(b.ingredient.name!);
      if (result != 0) {
        return result;
      }
      return a.ingredient.unit!.compareTo(b.ingredient.unit!);
    });

    String previousIngredientName = '';
    String previousIngredientUnit = '';
    int returnListIndex = 0;

    for (int i = 0; i < ingredientListByRecipeInCart.length; i++) {
      final ingredientByRecipeInCart = ingredientListByRecipeInCart[i];

      /// ingredientNameとingredientUnitが前のものと同じ場合の処理
      if (ingredientByRecipeInCart.ingredient.name == previousIngredientName &&
          ingredientByRecipeInCart.ingredient.unit == previousIngredientUnit &&
          i != 0) {
        // 元々のtotalAmount
        String previousTotalAmount =
            totaledIngredientListInCart[returnListIndex - 1]
                .ingredientInCart
                .ingredientTotalAmount;

        // 新たに追加するtotalAmount
        String addTotalAmount = calculation.executeMultiply(
            ingredientByRecipeInCart.countInCart,
            ingredientByRecipeInCart.ingredient.amount);

        // totalAmountの計算
        String totalAmount =
            calculation.executeAdd(previousTotalAmount, addTotalAmount);

        // totalAmountを更新
        totaledIngredientListInCart[returnListIndex - 1]
            .ingredientInCart
            .ingredientTotalAmount = totalAmount;

        RecipeByIngredientInCart recipeByIngredientInCart =
            RecipeByIngredientInCart(
                recipeId: ingredientByRecipeInCart.recipeId,
                recipeName: ingredientByRecipeInCart.recipeName,
                forHowManyPeople: ingredientByRecipeInCart.forHowManyPeople,
                countInCart: ingredientByRecipeInCart.countInCart,
                ingredientAmount: addTotalAmount);
        totaledIngredientListInCart[returnListIndex - 1]
            .recipeListByIngredientInCart
            .add(recipeByIngredientInCart);
      }

      /// ingredientNameとingredientUnitが前のものと異なる場合の処理
      else {
        previousIngredientName = ingredientByRecipeInCart.ingredient.name!;
        previousIngredientUnit = ingredientByRecipeInCart.ingredient.unit!;

        String totalAmount = calculation.executeMultiply(
            ingredientByRecipeInCart.countInCart,
            ingredientByRecipeInCart.ingredient.amount);

        // ingredient系
        IngredientInCart ingredientInCart = IngredientInCart(
            ingredientName: ingredientByRecipeInCart.ingredient.name!,
            ingredientTotalAmount: totalAmount,
            ingredientUnit: ingredientByRecipeInCart.ingredient.unit!);

        // recipeList系
        List<RecipeByIngredientInCart> recipeForIngredientInCartList = [];
        RecipeByIngredientInCart recipeForIngredientInCart =
            RecipeByIngredientInCart(
                recipeId: ingredientByRecipeInCart.recipeId,
                recipeName: ingredientByRecipeInCart.recipeName,
                forHowManyPeople: ingredientByRecipeInCart.forHowManyPeople,
                countInCart: ingredientByRecipeInCart.countInCart,
                ingredientAmount: totalAmount);
        recipeForIngredientInCartList.add(recipeForIngredientInCart);

        // returnするobject
        TotaledIngredientInCart ingredientInCartPerInRecipeList =
            TotaledIngredientInCart(
                ingredientInCart: ingredientInCart,
                recipeListByIngredientInCart: recipeForIngredientInCartList);

        totaledIngredientListInCart.add(ingredientInCartPerInRecipeList);
        returnListIndex += 1;
      }
    }

    return totaledIngredientListInCart;
  }

  /// cart_listでの処理
  List<TotaledIngredientInCart> createBuyList(
      List<TotaledIngredientInCart> list) {
    CartItemRepository cartItemRepository = CartItemRepository();
    List<TotaledIngredientInCart> buyList = [];

    for (var ingredient in list) {
      String id = ingredient.ingredientInCart.ingredientName +
          ingredient.ingredientInCart.ingredientUnit;
      CartItem cartItem = cartItemRepository.fetchItem(id);
      if (cartItem.isInBuyList == true) {
        buyList.add(ingredient);
      }
    }

    return buyList;
  }

  List<TotaledIngredientInCart> createNotBuyList(
      List<TotaledIngredientInCart> list) {
    CartItemRepository cartItemRepository = CartItemRepository();
    List<TotaledIngredientInCart> notBuyList = [];

    for (var ingredient in list) {
      String id = ingredient.ingredientInCart.ingredientName +
          ingredient.ingredientInCart.ingredientUnit;
      CartItem cartItem = cartItemRepository.fetchItem(id);
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

  Future toggleIsChecked(String id, bool isChecked) async {
    final item = _cartItemRepository.fetchItem(id);
    _cartItemRepository.putIsChecked(item, isChecked);
  }

  Future toggleIsInBuyList(String id) async {
    final item = _cartItemRepository.fetchItem(id);
    final isInBuyList = !item.isInBuyList;
    _cartItemRepository.putIsNeed(item, isInBuyList);
  }
}
