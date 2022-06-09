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

  List<TotaledIngredientListInCart> createIngredientListInCartPerRecipeList(
      List<IngredientByRecipeInCart> ingredientListByRecipeInCart) {
    Calculation calculation = Calculation();

    List<TotaledIngredientListInCart> totaledIngredientListInCart = [];

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
      /// ingredientNameとingredientUnitが前のものと同じ場合の処理
      if (ingredientListByRecipeInCart[i].ingredient.name == previousIngredientName &&
          ingredientListByRecipeInCart[i].ingredient.unit ==
              previousIngredientUnit &&
          i != 0) {
        // 元々のtotalAmount
        String previousTotalAmount =
            totaledIngredientListInCart[returnListIndex - 1]
                .ingredientInCart
                .ingredientTotalAmount;

        // 新たに追加するtotalAmount
        String addTotalAmount = calculation.executeMultiply(
            ingredientListByRecipeInCart[i].countInCart,
            ingredientListByRecipeInCart[i].ingredient.amount);

        // totalAmountの計算
        String totalAmount =
            calculation.executeAdd(previousTotalAmount, addTotalAmount);

        // totalAmountを更新
        totaledIngredientListInCart[returnListIndex - 1]
            .ingredientInCart
            .ingredientTotalAmount = totalAmount;

        RecipeByIngredientInCart recipeForIngredientInCart =
            RecipeByIngredientInCart(
                recipeId: ingredientListByRecipeInCart[i].recipeId,
                recipeName: ingredientListByRecipeInCart[i].recipeName,
                forHowManyPeople:
                    ingredientListByRecipeInCart[i].forHowManyPeople,
                countInCart: ingredientListByRecipeInCart[i].countInCart,
                ingredientAmount: addTotalAmount);
        totaledIngredientListInCart[returnListIndex - 1]
            .recipeListByIngredientInCart
            .add(recipeForIngredientInCart);
      }

      /// ingredientNameとingredientUnitが前のものと異なる場合の処理
      else {
        previousIngredientName =
            ingredientListByRecipeInCart[i].ingredient.name!;
        previousIngredientUnit =
            ingredientListByRecipeInCart[i].ingredient.unit!;

        String totalAmount = calculation.executeMultiply(
            ingredientListByRecipeInCart[i].countInCart,
            ingredientListByRecipeInCart[i].ingredient.amount);

        // ingredient系
        IngredientInCart ingredientInCart = IngredientInCart(
            ingredientName: ingredientListByRecipeInCart[i].ingredient.name!,
            ingredientTotalAmount: totalAmount,
            ingredientUnit: ingredientListByRecipeInCart[i].ingredient.unit!);

        // recipeList系
        List<RecipeByIngredientInCart> recipeForIngredientInCartList = [];
        RecipeByIngredientInCart recipeForIngredientInCart =
            RecipeByIngredientInCart(
                recipeId: ingredientListByRecipeInCart[i].recipeId,
                recipeName: ingredientListByRecipeInCart[i].recipeName,
                forHowManyPeople:
                    ingredientListByRecipeInCart[i].forHowManyPeople,
                countInCart: ingredientListByRecipeInCart[i].countInCart,
                ingredientAmount: totalAmount);
        recipeForIngredientInCartList.add(recipeForIngredientInCart);

        // returnするobject
        TotaledIngredientListInCart ingredientInCartPerInRecipeList =
            TotaledIngredientListInCart(
                ingredientInCart: ingredientInCart,
                recipeListByIngredientInCart: recipeForIngredientInCartList);

        totaledIngredientListInCart.add(ingredientInCartPerInRecipeList);
        returnListIndex += 1;
      }
    }

    return totaledIngredientListInCart;
  }

  /// cart_listでの処理
  List<TotaledIngredientListInCart> createBuyList(
      List<TotaledIngredientListInCart> list) {
    CartItemRepository cartItemRepository = CartItemRepository();
    List<TotaledIngredientListInCart> buyList = [];

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

  List<TotaledIngredientListInCart> createNotBuyList(
      List<TotaledIngredientListInCart> list) {
    CartItemRepository cartItemRepository = CartItemRepository();
    List<TotaledIngredientListInCart> notBuyList = [];

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
