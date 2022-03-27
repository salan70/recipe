import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/repository/recipe_repository.dart';
import 'package:fraction/fraction.dart';

import '../../domain/cart.dart';

class CartListModel extends ChangeNotifier {
  List<IngredientPerInCartRecipe> createIngredientPerInCartRecipeList(
      RecipeListInCart recipe, List<Ingredient> ingredientList) {
    List<IngredientPerInCartRecipe> ingredientPerInCartRecipeList = [];

    for (var item in ingredientList) {
      Ingredient ingredient = Ingredient(
          id: item.id, name: item.name, amount: item.amount, unit: item.unit);
      IngredientPerInCartRecipe ingredientPerInCartRecipe =
          IngredientPerInCartRecipe(
              recipeId: recipe.recipeId!,
              recipeName: recipe.recipeName!,
              forHowManyPeople: recipe.forHowManyPeople!,
              countInCart: recipe.countInCart!,
              ingredient: ingredient);

      ingredientPerInCartRecipeList.add(ingredientPerInCartRecipe);
    }

    return ingredientPerInCartRecipeList;
  }

  List<IngredientInCartPerRecipeList> createIngredientListInCartPerRecipeList(
      List<IngredientPerInCartRecipe> ingredientPerInCartRecipeList) {
    List<IngredientInCartPerRecipeList> ingredientListInCartPerRecipeList = [];

    // ingredientNameとingredientUnitでソート
    ingredientPerInCartRecipeList.sort((a, b) {
      int result = a.ingredient.name!.compareTo(b.ingredient.name!);
      if (result != 0) return result;
      return a.ingredient.unit!.compareTo(b.ingredient.unit!);
    });

    String previousIngredientName = '';
    String previousIngredientUnit = '';
    int returnListIndex = 0;

    for (int i = 0; i < ingredientPerInCartRecipeList.length; i++) {
      /// ingredientNameとingredientUnitが前のものと同じ場合の処理
      if (ingredientPerInCartRecipeList[i].ingredient.name == previousIngredientName &&
          ingredientPerInCartRecipeList[i].ingredient.unit ==
              previousIngredientUnit &&
          i != 0) {
        // 元々のtotalAmount
        String previousTotalAmount =
            ingredientListInCartPerRecipeList[returnListIndex - 1]
                .ingredientInCart
                .ingredientTotalAmount;
        String previousTotalAmountType = checkAmountType(previousTotalAmount);

        // 新たに追加するtotalAmount
        String addAmountType =
            checkAmountType(ingredientPerInCartRecipeList[i].ingredient.amount);
        String addTotalAmount = calcAmount(
            ingredientPerInCartRecipeList[i].countInCart,
            ingredientPerInCartRecipeList[i].ingredient.amount,
            addAmountType);
        String addTotalAmountType = checkAmountType(addTotalAmount);
        if (addTotalAmount.endsWith('.0')) {
          final pos = addTotalAmount.length - 2;
          addTotalAmount = addTotalAmount.substring(0, pos);
        }

        // totalAmountの計算
        String calcType =
            checkCalcType(previousTotalAmountType, addTotalAmountType);
        String totalAmount =
            calcTotalAmount(previousTotalAmount, addTotalAmount, calcType);
        if (totalAmount.endsWith('.0')) {
          final pos = totalAmount.length - 2;
          totalAmount = totalAmount.substring(0, pos);
        }

        ingredientListInCartPerRecipeList[returnListIndex - 1]
            .ingredientInCart
            .ingredientTotalAmount = totalAmount;

        RecipeForIngredientInCart recipeForIngredientInCart =
            RecipeForIngredientInCart(
                recipeId: ingredientPerInCartRecipeList[i].recipeId,
                recipeName: ingredientPerInCartRecipeList[i].recipeName,
                forHowManyPeople:
                    ingredientPerInCartRecipeList[i].forHowManyPeople,
                countInCart: ingredientPerInCartRecipeList[i].countInCart,
                ingredientAmount: addTotalAmount);
        ingredientListInCartPerRecipeList[returnListIndex - 1]
            .recipeForIngredientInCartList
            .add(recipeForIngredientInCart);
      }

      /// ingredientNameとingredientUnitが前のものと異なる場合の処理
      else {
        previousIngredientName =
            ingredientPerInCartRecipeList[i].ingredient.name!;
        previousIngredientUnit =
            ingredientPerInCartRecipeList[i].ingredient.unit!;

        String amountType =
            checkAmountType(ingredientPerInCartRecipeList[i].ingredient.amount);
        String totalAmount = calcAmount(
            ingredientPerInCartRecipeList[i].countInCart,
            ingredientPerInCartRecipeList[i].ingredient.amount,
            amountType);
        print(totalAmount);
        // 整数の場合,「.0」を削除する
        if (totalAmount.endsWith('.0')) {
          final pos = totalAmount.length - 2;
          totalAmount = totalAmount.substring(0, pos);
        }

        // ingredient系
        IngredientInCart ingredientInCart = IngredientInCart(
            ingredientName: ingredientPerInCartRecipeList[i].ingredient.name!,
            ingredientTotalAmount: totalAmount,
            ingredientUnit: ingredientPerInCartRecipeList[i].ingredient.unit!);

        // recipeList系
        List<RecipeForIngredientInCart> recipeForIngredientInCartList = [];
        RecipeForIngredientInCart recipeForIngredientInCart =
            RecipeForIngredientInCart(
                recipeId: ingredientPerInCartRecipeList[i].recipeId,
                recipeName: ingredientPerInCartRecipeList[i].recipeName,
                forHowManyPeople:
                    ingredientPerInCartRecipeList[i].forHowManyPeople,
                countInCart: ingredientPerInCartRecipeList[i].countInCart,
                ingredientAmount: totalAmount);
        recipeForIngredientInCartList.add(recipeForIngredientInCart);

        // returnするobject
        IngredientInCartPerRecipeList ingredientInCartPerInRecipeList =
            IngredientInCartPerRecipeList(
                ingredientInCart: ingredientInCart,
                recipeForIngredientInCartList: recipeForIngredientInCartList);

        ingredientListInCartPerRecipeList.add(ingredientInCartPerInRecipeList);
        returnListIndex += 1;
      }
    }

    return ingredientListInCartPerRecipeList;
  }

  String checkAmountType(String? amount) {
    String amountType = 'double';

    if (amount == null) {
      amountType = 'nullOrBlank';
    } else if (amount == '') {
      amountType = 'nullOrBlank';
    } else if (amount.contains('/')) {
      print(3);
      try {
        Fraction.fromString(amount);
        amountType = 'fraction';
      } catch (e) {
        try {
          MixedFraction.fromString(amount);
          amountType = 'mixed fraction';
        } catch (e) {
          amountType = 'error';
          print(e);
        }
      }
    }
    return amountType;
  }

  String checkCalcType(
      String previousTotalAmountType, String addTotalAmountType) {
    String calcType = 'double';

    if (previousTotalAmountType.contains('fraction') ||
        addTotalAmountType.contains('fraction')) {
      if (previousTotalAmountType == 'double' ||
          addTotalAmountType == 'double') {
        calcType = 'double&fraction';
      } else {
        if (previousTotalAmountType.contains('mixed fraction') ||
            addTotalAmountType.contains('mixed fraction')) {
          calcType = 'mixed fraction';
        }
        calcType = 'fraction';
      }
    }
    return calcType;
  }

  String calcAmount(int countInCart, String? amount, String amountType) {
    String result = '';

    if (amountType != 'nullOrBlank') {
      if (amountType == 'double') {
        result = (countInCart * double.parse(amount!)).toString();
      } else if (amountType == 'fraction') {
        result = (Fraction.fromString(countInCart.toString()) *
                Fraction.fromString(amount!))
            .toString();
      } else if (amountType == 'mixed fraction') {
        result = (MixedFraction.fromFraction(
                    Fraction.fromString(countInCart.toString())) *
                MixedFraction.fromString(amount!))
            .toString();
      }
    }

    return result;
  }

  String calcTotalAmount(
      String previousTotalAmount, String addTotalAmount, String calcType) {
    String totalAmount = '';

    // ''が含まれている場合に関する処理
    if (previousTotalAmount == '') {
      if (addTotalAmount != '') {
        totalAmount = addTotalAmount;
      }
    } else if (addTotalAmount == '') {
      totalAmount = previousTotalAmount;
    }
    // 計算するのはここから
    else if (calcType == 'double') {
      totalAmount =
          (double.parse(previousTotalAmount) + double.parse(addTotalAmount))
              .toString();
    } else if (calcType == 'double&fraction') {
      // fractionをdoubleにcast
      if (previousTotalAmount.contains('/')) {
        previousTotalAmount =
            Fraction.fromString(previousTotalAmount).toDouble().toString();
      } else {
        addTotalAmount =
            Fraction.fromString(addTotalAmount).toDouble().toString();
      }
      totalAmount =
          (double.parse(previousTotalAmount) + double.parse(addTotalAmount))
              .toString();
    } else if (calcType == 'fraction') {
      totalAmount = (Fraction.fromString(previousTotalAmount) +
              Fraction.fromString(addTotalAmount))
          .toString();
    }

    return totalAmount;
  }
}
