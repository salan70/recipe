import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/repository/recipe_repository.dart';
import 'package:riverpod/riverpod.dart';

import 'package:recipe/domain/recipe.dart';

// class RecipeStreamNotifier extends StateNotifier<List<RecipeStream>> {
//   RecipeStreamNotifier({required this.user, this.recipeStream}) : super([]);
//
//   final User user;
//   List<RecipeStream>? recipeStream;
// }
