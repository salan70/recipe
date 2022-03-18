import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/repository/cart_repository.dart';
import 'package:recipe/repository/recipe_repository.dart';
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

final recipeListStreamProvider = StreamProvider<List<Recipe>>((ref) {
  final user = ref.watch(authControllerProvider);

  RecipeRepository recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipeList();
});

final ingredientListStreamProviderFamily =
    StreamProviderFamily<List<Ingredient>, String>((ref, recipeId) {
  final user = ref.watch(authControllerProvider);

  RecipeRepository recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchIngredientList(recipeId);
});

final procedureListStreamProviderFamily =
    StreamProviderFamily<List<Procedure>, String>((ref, recipeId) {
  final user = ref.watch(authControllerProvider);

  RecipeRepository recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchProcedureList(recipeId);
});

final recipeStreamProviderFamily =
    StreamProviderFamily<Recipe, String>((ref, recipeId) {
  final user = ref.watch(authControllerProvider);

  RecipeRepository recipeRepository = RecipeRepository(user: user!);

  return recipeRepository.fetchRecipe(recipeId);
});

/// reordarale_text_field
final ingredientListNotifierProvider =
    StateNotifierProvider.autoDispose<IngredientListNotifier, List<Ingredient>>(
  (ref) => IngredientListNotifier(),
);

final procedureListNotifierProvider =
    StateNotifierProvider.autoDispose<ProcedureListNotifier, List<Procedure>>(
  (ref) => ProcedureListNotifier(),
);

// ingredient
final nameIsChangedProvider = StateProvider.autoDispose((ref) => false);
final amountIsChangedProvider = StateProvider.autoDispose((ref) => false);
// procedure
final contentIsChangedProvider = StateProvider.autoDispose((ref) => false);

/// basket
final recipeNumCountProviderFamily =
    StateProvider.family.autoDispose<int, int?>((count, initialCount) {
  int count = 1;

  if (initialCount != null) {
    count = initialCount;
  }
  return count;
});

// final recipeNumCountProvider = StateProvider.autoDispose((ref) => 1);

final inCartRecipeListStreamProvider =
    StreamProvider<List<InCartRecipe>>((ref) {
  final user = ref.watch(authControllerProvider);
  CartRepository cartRepository = CartRepository(user: user!);

  return cartRepository.fetchRecipeRefList();
});

final inCartRecipeStreamProviderFamily =
    StreamProviderFamily<Recipe, String>((ref, recipeId) {
  final user = ref.watch(authControllerProvider);
  CartRepository cartRepository = CartRepository(user: user!);

  return cartRepository.fetchRecipe(recipeId);
});
