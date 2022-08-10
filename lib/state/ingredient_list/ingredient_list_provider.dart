import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/recipe.dart';
import 'ingredient_list_state.dart';

final ingredientListNotifierProvider =
    StateNotifierProvider.autoDispose<IngredientListNotifier, List<Ingredient>>(
  (ref) => IngredientListNotifier(),
);
