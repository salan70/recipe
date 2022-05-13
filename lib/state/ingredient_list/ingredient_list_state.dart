import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:uuid/uuid.dart';

class IngredientListNotifier extends StateNotifier<List<Ingredient>> {
  IngredientListNotifier()
      : super([
          Ingredient(
            id: Uuid().v4(),
            name: '',
            amount: '',
            unit: null,
          ),
        ]);

  void add(Ingredient ingredient) {
    state = [...state, ingredient];
  }

  void remove(String id) {
    state = [
      for (final ingredient in state)
        if (ingredient.id != id) ingredient,
    ];
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = state.removeAt(oldIndex);
    state = [...state..insert(newIndex, item)];
  }

  void editName(String id, String name) {
    state = [
      for (final ingredient in state)
        if (ingredient.id == id)
          ingredient.copyWith(name: name)
        else
          ingredient,
    ];
  }

  void editAmount(String id, String amount) {
    state = [
      for (final ingredient in state)
        if (ingredient.id == id)
          ingredient.copyWith(amount: amount)
        else
          ingredient,
    ];
  }

  void editUnit(String id, String unit) {
    state = [
      for (final ingredient in state)
        if (ingredient.id == id)
          ingredient.copyWith(unit: unit)
        else
          ingredient,
    ];
  }

  List<Ingredient> getList(List<Ingredient> ingredientList) {
    return state = ingredientList;
  }
}
