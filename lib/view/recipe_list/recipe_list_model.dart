import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/recipe.dart';

class RecipeListModel extends ChangeNotifier {
  String toOutputIngredientText(List<Ingredient> ingredients) {
    final List<String> ingredientTextList = List.filled(ingredients.length, '');
    String outputIngredientText = '';
    int ingredientIndex = 0;

    for (var ingredient in ingredients) {
      String ingredientName = ingredient.name.toString();
      String ingredientAmount = ingredient.amount.toString();
      String ingredientUnit = ingredient.unit.toString();
      String ingredientText =
          ingredientName + ' ' + ingredientAmount + ingredientUnit + ', ';
      ingredientTextList[ingredientIndex] = ingredientText;
      ingredientIndex += 1;
      // print(ingredientTextList[index]);
      outputIngredientText += ingredientText;
    }

    return outputIngredientText;
  }
}
