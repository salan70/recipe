import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod/riverpod.dart';

import 'package:recipe/domain/recipe.dart';

class RecipeStreamNotifier extends StateNotifier<List<Recipe>> {
  RecipeStreamNotifier() : super([]);
}
