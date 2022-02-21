import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/view/add_recipe/add_redipe_model.dart';
import 'package:recipe/view/recipe_list/recipe_list_model.dart';
import 'domain/recipe.dart';
import 'package:recipe/parts/reordable_text_field/procedures.dart';
import 'package:recipe/parts/reordable_text_field/ingredients.dart';
import 'package:recipe/auth/auth_controller.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(ref.read)..appStarted(),
);

final recipeListNotifierProvider =
    StateNotifierProvider.autoDispose<RecipeListNotifier, List<Recipe>>((ref) {
  return RecipeListNotifier();
});

final imageFileNotifierProvider =
    StateNotifierProvider.autoDispose<ImageFileNotifier, ImageFile>((ref) {
  return ImageFileNotifier();
});

// 匿名認証用?
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final ingredientListNotifierProvider =
    StateNotifierProvider.autoDispose<IngredientListNotifier, List<Ingredient>>(
  (ref) => IngredientListNotifier(),
);

final procedureListNotifierProvider =
    StateNotifierProvider.autoDispose<ProcedureListNotifier, List<Procedure>>(
  (ref) => ProcedureListNotifier(),
);

final recipesStreamProvider = StreamProvider<List<Recipe>>((ref) {
  final authControllerState = ref.watch(authControllerProvider);

  final String uid = authControllerState!.uid;
  RecipeListModel recipeListModel = RecipeListModel();

  return recipeListModel.fetchRecipeList(uid);
});
