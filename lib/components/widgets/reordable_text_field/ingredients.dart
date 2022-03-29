// outside
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

// inside
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/components/providers.dart';
import 'package:recipe/components/validation/validation.dart';

class IngredientListNotifier extends StateNotifier<List<Ingredient>> {
  IngredientListNotifier()
      : super([
          Ingredient(
            id: Uuid().v4(),
            name: '',
            amount: '',
            unit: '個',
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

class IngredientListWidget extends ConsumerWidget {
  const IngredientListWidget({Key? key, this.recipe}) : super(key: key);

  final Recipe? recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientList = ref.watch(ingredientListNotifierProvider);
    final ingredientListNotifier =
        ref.watch(ingredientListNotifierProvider.notifier);

    final Validation validation = Validation();

    final nameIsChanged = ref.watch(nameIsChangedProvider);
    final nameIsChangedNotifier = ref.watch(nameIsChangedProvider.notifier);

    final amountIsChanged = ref.watch(nameIsChangedProvider);
    final amountIsChangedNotifier = ref.watch(nameIsChangedProvider.notifier);

    return Column(
      children: [
        Builder(builder: (context) {
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) =>
                ingredientListNotifier.reorder(oldIndex, newIndex),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              for (int index = 0; index < ingredientList.length; index++)
                Slidable(
                  key: ValueKey(ingredientList[index].id),
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: [
                    IconSlideAction(
                      color: Colors.red,
                      iconWidget: Text('delete'),
                      onTap: () => ingredientListNotifier
                          .remove(ingredientList[index].id),
                    ),
                  ],
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: TextField(
                            controller: nameIsChanged == false
                                ? TextEditingController(
                                    text: ingredientList[index].name)
                                : null,
                            onChanged: (String value) {
                              ingredientListNotifier.editName(
                                  ingredientList[index].id, value);
                              nameIsChangedNotifier.update((state) => true);
                            },
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 1,
                          child: TextField(
                            controller: amountIsChanged == false
                                ? TextEditingController(
                                    text:
                                        ingredientList[index].amount.toString())
                                : null,
                            keyboardType: TextInputType.datetime,
                            maxLength: 5,
                            decoration: InputDecoration(
                              counterText: '',
                              // labelText: "2000",
                              errorText: validation
                                  .errorText(ingredientList[index].amount),
                            ),
                            onChanged: (value) {
                              ingredientListNotifier.editAmount(
                                  ingredientList[index].id, value);
                              amountIsChangedNotifier.update((state) => true);
                            },
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: DropdownButton<String>(
                          value: ingredientList[index].unit,
                          onChanged: (String? value) {
                            ingredientListNotifier.editUnit(
                                ingredientList[index].id, value!);
                          },
                          items: ["個", "g", "本", "大さじ", "小さじ"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Icon(Icons.drag_handle),
                    ],
                  ),
                ),
            ],
          );
        }),
        TextButton(
          onPressed: () {
            final Ingredient ingredient = Ingredient(
              id: Uuid().v4(),
              name: '',
              amount: '',
              unit: '個',
            );
            ingredientListNotifier.add(ingredient);
          },
          child: Text("追加"),
        )
      ],
    );
  }
}
