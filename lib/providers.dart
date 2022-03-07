import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/repository/fetch_recipe.dart';
import 'package:recipe/view/add_recipe/add_recipe_model.dart';
import 'package:recipe/view/recipe_list/recipe_list_model.dart';
import 'domain/recipe.dart';
import 'package:recipe/parts/reordable_text_field/procedures.dart';
import 'package:recipe/parts/reordable_text_field/ingredients.dart';
import 'package:recipe/auth/auth_controller.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(ref.read)..appStarted(),
);

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
  final user = authControllerState;

  FetchRecipeRepository fetchRecipeRepository = FetchRecipeRepository(user);

  return fetchRecipeRepository.fetchRecipeList(user!.uid);
});

final ingredientsStreamProviderFamily =
    StreamProviderFamily<List<Ingredient>, String>((ref, recipeId) {
  final authControllerState = ref.watch(authControllerProvider);
  final user = authControllerState;

  FetchRecipeRepository fetchRecipeRepository = FetchRecipeRepository(user);

  return fetchRecipeRepository.fetchIngredientList(user!.uid, recipeId);
});

final proceduresStreamProviderFamily =
    StreamProviderFamily<List<Procedure>, String>((ref, recipeId) {
  final authControllerState = ref.watch(authControllerProvider);
  final user = authControllerState;

  FetchRecipeRepository fetchRecipeRepository = FetchRecipeRepository(user);

  return fetchRecipeRepository.fetchProcedureList(user!.uid, recipeId);
});

final recipesStreamProviderFamily =
    StreamProviderFamily<List<Recipe>, String>((ref, docRef) {
  final user = ref.watch(authControllerProvider);

  FetchRecipeRepository fetchRecipeRepository = FetchRecipeRepository(user);

  return fetchRecipeRepository.fetchRecipeList(user!.uid);
});
