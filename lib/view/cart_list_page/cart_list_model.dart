import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe/components/calculation/calculation.dart';
import 'package:recipe/domain/recipe.dart';
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
    Calculation calculation = Calculation();

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

        // 新たに追加するtotalAmount
        String addTotalAmount = calculation.executeMultiply(
            ingredientPerInCartRecipeList[i].countInCart,
            ingredientPerInCartRecipeList[i].ingredient.amount);

        // totalAmountの計算
        String totalAmount =
            calculation.executeAdd(previousTotalAmount, addTotalAmount);

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

        String totalAmount = calculation.executeMultiply(
            ingredientPerInCartRecipeList[i].countInCart,
            ingredientPerInCartRecipeList[i].ingredient.amount);

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

  // String checkAmountType(String? amount) {
  //   String amountType = 'double';
  //
  //   if (amount == null) {
  //     amountType = 'nullOrBlank';
  //   } else if (amount == '') {
  //     amountType = 'nullOrBlank';
  //   } else if (amount.contains('/')) {
  //     try {
  //       amount.toFraction();
  //       amountType = 'fraction';
  //     } catch (e) {
  //       try {
  //         amount.toMixedFraction();
  //         amountType = 'mixed fraction';
  //       } catch (e) {
  //         amountType = 'error';
  //         print(e);
  //       }
  //     }
  //   }
  //
  //   return amountType;
  // }
  //
  // String checkCalcType(
  //     String previousTotalAmountType, String addTotalAmountType) {
  //   String calcType = 'double';
  //
  //   if (previousTotalAmountType.contains('fraction') ||
  //       addTotalAmountType.contains('fraction')) {
  //     if (previousTotalAmountType == 'double' ||
  //         addTotalAmountType == 'double') {
  //       calcType = 'double&fraction';
  //     } else {
  //       if (previousTotalAmountType.contains('mixed fraction') ||
  //           addTotalAmountType.contains('mixed fraction')) {
  //         calcType = 'mixed fraction';
  //       }
  //       calcType = 'fraction';
  //     }
  //   }
  //   return calcType;
  // }
  //
  // String calcAmount(int countInCart, String? amount, String amountType) {
  //   String result = '';
  //
  //   if (amountType != 'nullOrBlank') {
  //     if (amountType == 'double') {
  //       result = (countInCart * double.parse(amount!)).toString();
  //     } else if (amountType == 'fraction') {
  //       result = (countInCart.toFraction() * amount!.toFraction()).toString();
  //     } else if (amountType == 'mixed fraction') {
  //       result = (countInCart.toMixedFraction() * amount!.toMixedFraction())
  //           .toString();
  //       if (result.contains(' 0/')) {
  //         result = (countInCart.toMixedFraction() * amount.toMixedFraction())
  //             .toDouble()
  //             .toString();
  //       }
  //     }
  //   }
  //
  //   return result;
  // }
  //
  // String calcTotalAmount(
  //     String previousTotalAmount, String addTotalAmount, String calcType) {
  //   String totalAmount = '';
  //
  //   // ''が含まれている場合に関する処理
  //   if (previousTotalAmount == '') {
  //     if (addTotalAmount != '') {
  //       totalAmount = addTotalAmount;
  //     }
  //   } else if (addTotalAmount == '') {
  //     totalAmount = previousTotalAmount;
  //   }
  //   // 計算するのはここから
  //   else if (calcType == 'double') {
  //     totalAmount =
  //         (double.parse(previousTotalAmount) + double.parse(addTotalAmount))
  //             .toString();
  //   } else if (calcType == 'double&fraction') {
  //     // fraction or mixedFraction をdoubleにcast
  //     if (previousTotalAmount.contains('/')) {
  //       try {
  //         previousTotalAmount =
  //             previousTotalAmount.toMixedFraction().toDouble().toString();
  //         print(
  //             'previousTotalAmount ($previousTotalAmount) Type is Mixed Fraction');
  //       } catch (e) {
  //         try {
  //           previousTotalAmount =
  //               previousTotalAmount.toFraction().toDouble().toString();
  //           print(
  //               'previousTotalAmount ($previousTotalAmount) Type is Fraction');
  //         } catch (e) {
  //           print(e);
  //         }
  //       }
  //     } else {
  //       try {
  //         addTotalAmount =
  //             addTotalAmount.toMixedFraction().toDouble().toString();
  //         print('addTotalAmount ($addTotalAmount) Type is Mixed Fraction');
  //       } catch (e) {
  //         try {
  //           addTotalAmount = addTotalAmount.toFraction().toDouble().toString();
  //           print('addTotalAmount ($addTotalAmount) Type is Fraction');
  //         } catch (e) {
  //           print(e);
  //         }
  //       }
  //       totalAmount =
  //           (double.parse(previousTotalAmount) + double.parse(addTotalAmount))
  //               .toString();
  //     }
  //   } else if (calcType == 'fraction') {
  //     totalAmount =
  //         (previousTotalAmount.toFraction() + addTotalAmount.toFraction())
  //             .toString();
  //   } else if (calcType == 'mixed fraction') {
  //     //   try{
  //     //     previousTotalAmount = previousTotalAmount.toFraction().toString();
  //     //   }catch(e){
  //     //     previousTotalAmount = previousTotalAmount.toMixedFraction().toString();
  //     //   }
  //     //   try{
  //     //     addTotalAmount = previousTotalAmount.toFraction().toString();
  //     //   }catch(e){
  //     //     addTotalAmount = previousTotalAmount.toMixedFraction().toString();
  //     //   }
  //     totalAmount = (previousTotalAmount.toMixedFraction() +
  //             addTotalAmount.toMixedFraction())
  //         .toString();
  //   }
  //
  //   return totalAmount;
  // }
}
