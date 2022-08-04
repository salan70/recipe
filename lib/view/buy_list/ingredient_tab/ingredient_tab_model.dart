import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/components/calculation/calculation.dart';
import 'package:recipe/domain/buy_list.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';
import 'package:recipe/repository/firebase/cart_repository.dart';
import 'package:recipe/repository/hive/cart_item_repository.dart';

class IngredientTabModel extends ChangeNotifier {
  final _cartItemRepository = CartItemRepository();

  List<TotaledIngredient> castToTotaledIngredientList(
    List<RecipeInCart> recipeListInCart,
  ) {
    final ingredientListPerRecipe = <IngredientPerRecipe>[];

    for (final recipe in recipeListInCart) {
      _createIngredientListPerRecipe(recipe)
          .forEach(ingredientListPerRecipe.add);
    }

    return _createTotaledIngredientList(
      ingredientListPerRecipe,
    );
  }

  List<IngredientPerRecipe> _createIngredientListPerRecipe(
    RecipeInCart recipe,
  ) {
    final ingredientListPerRecipe = <IngredientPerRecipe>[];

    if (recipe.ingredientList != null) {
      for (final ingredient in recipe.ingredientList!) {
        final ingredientPerRecipe = IngredientPerRecipe(
          recipeId: recipe.recipeId!,
          recipeName: recipe.recipeName!,
          forHowManyPeople: recipe.forHowManyPeople!,
          countInCart: recipe.countInCart!,
          ingredient: ingredient,
        );

        ingredientListPerRecipe.add(ingredientPerRecipe);
      }
    }

    return ingredientListPerRecipe;
  }

  List<TotaledIngredient> _createTotaledIngredientList(
    List<IngredientPerRecipe> ingredientListPerRecipe,
  ) {
    final calculation = Calculation();

    final totaledIngredientList = <TotaledIngredient>[];

    // ingredientNameとingredientUnitでソート
    ingredientListPerRecipe.sort((a, b) {
      final result = a.ingredient.name!.compareTo(b.ingredient.name!);
      if (result != 0) {
        return result;
      }
      return a.ingredient.unit!.compareTo(b.ingredient.unit!);
    });

    var previousIngredientName = '';
    var previousIngredientUnit = '';
    var returnListIndex = 0;

    for (var i = 0; i < ingredientListPerRecipe.length; i++) {
      final ingredientPerRecipe = ingredientListPerRecipe[i];

      /// ingredientNameとingredientUnitが前のものと同じ場合の処理
      if (ingredientPerRecipe.ingredient.name == previousIngredientName &&
          ingredientPerRecipe.ingredient.unit == previousIngredientUnit &&
          i != 0) {
        // 元々のtotalAmount
        final previousTotalAmount = totaledIngredientList[returnListIndex - 1]
            .ingredientInCart
            .totalAmount;

        // 新たに追加するtotalAmount
        final addTotalAmount = calculation.executeMultiply(
          ingredientPerRecipe.countInCart,
          ingredientPerRecipe.ingredient.amount,
        );

        // totalAmountの計算
        final totalAmount =
            calculation.executeAdd(previousTotalAmount, addTotalAmount);

        // totalAmountを更新
        totaledIngredientList[returnListIndex - 1]
            .ingredientInCart
            .totalAmount = totalAmount;

        final recipePerIngredient = RecipePerIngredient(
          recipeId: ingredientPerRecipe.recipeId,
          recipeName: ingredientPerRecipe.recipeName,
          forHowManyPeople: ingredientPerRecipe.forHowManyPeople,
          countInCart: ingredientPerRecipe.countInCart,
          ingredientAmount: addTotalAmount,
        );
        totaledIngredientList[returnListIndex - 1]
            .recipeListPerIngredient
            .add(recipePerIngredient);
      }

      /// ingredientNameとingredientUnitが前のものと異なる場合の処理
      else {
        previousIngredientName = ingredientPerRecipe.ingredient.name!;
        previousIngredientUnit = ingredientPerRecipe.ingredient.unit!;

        final totalAmount = calculation.executeMultiply(
          ingredientPerRecipe.countInCart,
          ingredientPerRecipe.ingredient.amount,
        );

        // ingredient系
        final ingredientInCart = IngredientInCart(
          name: ingredientPerRecipe.ingredient.name!,
          totalAmount: totalAmount,
          unit: ingredientPerRecipe.ingredient.unit!,
        );

        // recipeList系
        final recipeListPerIngredient = <RecipePerIngredient>[];
        final recipeForIngredientInCart = RecipePerIngredient(
          recipeId: ingredientPerRecipe.recipeId,
          recipeName: ingredientPerRecipe.recipeName,
          forHowManyPeople: ingredientPerRecipe.forHowManyPeople,
          countInCart: ingredientPerRecipe.countInCart,
          ingredientAmount: totalAmount,
        );
        recipeListPerIngredient.add(recipeForIngredientInCart);

        // returnするobject
        final totaledIngredient = TotaledIngredient(
          ingredientInCart: ingredientInCart,
          recipeListPerIngredient: recipeListPerIngredient,
        );

        totaledIngredientList.add(totaledIngredient);
        returnListIndex += 1;
      }
    }

    return totaledIngredientList;
  }

  /// cart_listでの処理
  List<TotaledIngredient> createIngredientBuyList(
    List<TotaledIngredient> list,
  ) {
    final buyList = <TotaledIngredient>[];

    for (final ingredient in list) {
      final id =
          ingredient.ingredientInCart.name + ingredient.ingredientInCart.unit;
      final cartItem = _cartItemRepository.fetchCartItem(id);
      if (cartItem.isInBuyList == true) {
        buyList.add(ingredient);
      }
    }

    return buyList;
  }

  List<TotaledIngredient> createIngredientNotBuyList(
    List<TotaledIngredient> list,
  ) {
    final cartItemRepository = CartItemRepository();
    final notBuyList = <TotaledIngredient>[];

    for (final ingredient in list) {
      final id =
          ingredient.ingredientInCart.name + ingredient.ingredientInCart.unit;
      final cartItem = cartItemRepository.fetchCartItem(id);
      if (cartItem.isInBuyList == false) {
        notBuyList.add(ingredient);
      }
    }

    return notBuyList;
  }

  List<OtherBuyListItem> createOtherItemBuyList(
    List<OtherBuyListItem> list,
  ) {
    final cartItemRepository = CartItemRepository();
    final buyList = <OtherBuyListItem>[];

    for (final ocherItem in list) {
      final id = ocherItem.itemId;
      final cartItem = cartItemRepository.fetchCartItem(id!);
      if (cartItem.isInBuyList == true) {
        buyList.add(ocherItem);
      }
    }

    return buyList;
  }

  List<OtherBuyListItem> createOtherItemNotBuyList(
    List<OtherBuyListItem> list,
  ) {
    final cartItemRepository = CartItemRepository();
    final notBuyList = <OtherBuyListItem>[];

    for (final otherItem in list) {
      final id = otherItem.itemId;
      final cartItem = cartItemRepository.fetchCartItem(id!);
      if (cartItem.isInBuyList == false) {
        notBuyList.add(otherItem);
      }
    }

    return notBuyList;
  }

  Future<String?> deleteOtherBuyListItem(User user, String itemId) async {
    final cartRepository = CartRepository(user: user);
    try {
      await cartRepository.deleteOtherCartItem(itemId);
      await _cartItemRepository.deleteBuyListItem(itemId);
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
