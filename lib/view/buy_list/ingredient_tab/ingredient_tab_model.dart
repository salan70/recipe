import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/components/calculation/calculation.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';
import 'package:recipe/repository/firebase/cart_repository.dart';
import 'package:recipe/repository/hive/cart_item_repository.dart';

class IngredientTabModel extends ChangeNotifier {
  final _cartItemRepository = CartItemRepository();

  List<TotaledIngredientInCart> castToTotaledIngredientListInCart(
    List<RecipeInCart> recipeListInCart,
  ) {
    final ingredientPerInCartRecipeList = <IngredientByRecipeInCart>[];

    for (final recipe in recipeListInCart) {
      _createIngredientListByRecipeInCart(recipe)
          .forEach(ingredientPerInCartRecipeList.add);
    }

    return _createTotaledIngredientListInCart(
      ingredientPerInCartRecipeList,
    );
  }

  List<IngredientByRecipeInCart> _createIngredientListByRecipeInCart(
    RecipeInCart recipe,
  ) {
    final ingredientListByRecipeInCart = <IngredientByRecipeInCart>[];

    if (recipe.ingredientList != null) {
      for (final ingredient in recipe.ingredientList!) {
        final ingredientByRecipeInCart = IngredientByRecipeInCart(
          recipeId: recipe.recipeId!,
          recipeName: recipe.recipeName!,
          forHowManyPeople: recipe.forHowManyPeople!,
          countInCart: recipe.countInCart!,
          ingredient: Ingredient(
            id: ingredient.id,
            symbol: ingredient.symbol,
            name: ingredient.name,
            amount: ingredient.amount,
            unit: ingredient.unit,
          ),
        );

        ingredientListByRecipeInCart.add(ingredientByRecipeInCart);
      }
    }

    return ingredientListByRecipeInCart;
  }

  List<TotaledIngredientInCart> _createTotaledIngredientListInCart(
    List<IngredientByRecipeInCart> ingredientListByRecipeInCart,
  ) {
    final calculation = Calculation();

    final totaledIngredientListInCart = <TotaledIngredientInCart>[];

    // ingredientName???ingredientUnit????????????
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

      /// ingredientName???ingredientUnit???????????????????????????????????????
      if (ingredientByRecipeInCart.ingredient.name == previousIngredientName &&
          ingredientByRecipeInCart.ingredient.unit == previousIngredientUnit &&
          i != 0) {
        // ?????????totalAmount
        final previousTotalAmount =
            totaledIngredientListInCart[returnListIndex - 1]
                .ingredientInCart
                .ingredientTotalAmount;

        // ?????????????????????totalAmount
        final addTotalAmount = calculation.executeMultiply(
          ingredientByRecipeInCart.countInCart,
          ingredientByRecipeInCart.ingredient.amount,
        );

        // totalAmount?????????
        final totalAmount =
            calculation.executeAdd(previousTotalAmount, addTotalAmount);

        // totalAmount?????????
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

      /// ingredientName???ingredientUnit??????????????????????????????????????????
      else {
        previousIngredientName = ingredientByRecipeInCart.ingredient.name!;
        previousIngredientUnit = ingredientByRecipeInCart.ingredient.unit!;

        final totalAmount = calculation.executeMultiply(
          ingredientByRecipeInCart.countInCart,
          ingredientByRecipeInCart.ingredient.amount,
        );

        // ingredient???
        final ingredientInCart = IngredientInCart(
          ingredientName: ingredientByRecipeInCart.ingredient.name!,
          ingredientTotalAmount: totalAmount,
          ingredientUnit: ingredientByRecipeInCart.ingredient.unit!,
        );

        // recipeList???
        final recipeForIngredientInCartList = <RecipeByIngredientInCart>[];
        final recipeForIngredientInCart = RecipeByIngredientInCart(
          recipeId: ingredientByRecipeInCart.recipeId,
          recipeName: ingredientByRecipeInCart.recipeName,
          forHowManyPeople: ingredientByRecipeInCart.forHowManyPeople,
          countInCart: ingredientByRecipeInCart.countInCart,
          ingredientAmount: totalAmount,
        );
        recipeForIngredientInCartList.add(recipeForIngredientInCart);

        // return??????object
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

  /// cart_list????????????
  List<TotaledIngredientInCart> createIngredientBuyList(
    List<TotaledIngredientInCart> list,
  ) {
    final buyList = <TotaledIngredientInCart>[];

    for (final ingredient in list) {
      final id = ingredient.ingredientInCart.ingredientName +
          ingredient.ingredientInCart.ingredientUnit;
      final cartItem = _cartItemRepository.fetchCartItem(id);
      if (cartItem.isInBuyList == true) {
        buyList.add(ingredient);
      }
    }

    return buyList;
  }

  List<TotaledIngredientInCart> createIngredientNotBuyList(
    List<TotaledIngredientInCart> list,
  ) {
    final cartItemRepository = CartItemRepository();
    final notBuyList = <TotaledIngredientInCart>[];

    for (final ingredient in list) {
      final id = ingredient.ingredientInCart.ingredientName +
          ingredient.ingredientInCart.ingredientUnit;
      final cartItem = cartItemRepository.fetchCartItem(id);
      if (cartItem.isInBuyList == false) {
        notBuyList.add(ingredient);
      }
    }

    return notBuyList;
  }

  List<OtherCartItem> createOtherItemBuyList(
    List<OtherCartItem> list,
  ) {
    final cartItemRepository = CartItemRepository();
    final buyList = <OtherCartItem>[];

    for (final ocherItem in list) {
      final id = ocherItem.itemId;
      final cartItem = cartItemRepository.fetchCartItem(id!);
      if (cartItem.isInBuyList == true) {
        buyList.add(ocherItem);
      }
    }

    return buyList;
  }

  List<OtherCartItem> createOtherItemNotBuyList(
    List<OtherCartItem> list,
  ) {
    final cartItemRepository = CartItemRepository();
    final notBuyList = <OtherCartItem>[];

    for (final otherItem in list) {
      final id = otherItem.itemId;
      final cartItem = cartItemRepository.fetchCartItem(id!);
      if (cartItem.isInBuyList == false) {
        notBuyList.add(otherItem);
      }
    }

    return notBuyList;
  }

  Future<String?> deleteOtherCartItem(User user, String itemId) async {
    final cartRepository = CartRepository(user: user);
    try {
      await cartRepository.deleteOtherCartItem(itemId);
      await _cartItemRepository.deleteCartItem(itemId);
      return null;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  CartItem getCartItem(String id) {
    final cartItem = _cartItemRepository.fetchCartItem(id);
    return cartItem;
  }

  Future<void> toggleIsChecked({
    required String id,
    required bool isChecked,
  }) async {
    final item = _cartItemRepository.fetchCartItem(id);
    await _cartItemRepository.putIsChecked(item: item, isChecked: isChecked);
  }

  Future<void> toggleIsInBuyList(String id) async {
    final item = _cartItemRepository.fetchCartItem(id);
    final isInBuyList = !item.isInBuyList;
    await _cartItemRepository.putIsInBuyList(
      item: item,
      isInBuyList: isInBuyList,
    );
  }
}
