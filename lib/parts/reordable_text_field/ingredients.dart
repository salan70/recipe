// outside
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

// inside
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/providers.dart';
import 'package:recipe/parts/validation/validation.dart';

class IngredientListNotifier extends StateNotifier<List<Ingredient>> {
  IngredientListNotifier()
      : super([
          Ingredient(
            id: Uuid().v4(),
            name: "",
            amount: "",
            unit: "個",
            // formState: GlobalKey<FormState>()
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
}

class IngredientListWidget extends ConsumerWidget {
  const IngredientListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientList = ref.watch(ingredientListNotifierProvider);
    final ingredientListNotifier =
        ref.watch(ingredientListNotifierProvider.notifier);
    final Validation validation = Validation();

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
                      iconWidget: Text("delete"),
                      onTap: () => ingredientListNotifier
                          .remove(ingredientList[index].id),
                    ),
                  ],
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: InputDecoration(labelText: "ルッコラ"),
                            onChanged: (String value) {
                              ingredientListNotifier.editName(
                                  ingredientList[index].id, value);

                              ///テスト用
                              // print("--------name-------");
                              // for (int i = 0; i < ingredientList.length; i++) {
                              //   print(ingredientList[i].id +
                              //       ":" +
                              //       ingredientList[i].name +
                              //       ":" +
                              //       ingredientList[i].amount.toString() +
                              //       ":" +
                              //       ingredientList[i].unit);
                              // }
                            },
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 1,
                          child: TextField(
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              labelText: "2000",
                              errorText: validation
                                  .errorText(ingredientList[index].amount),
                            ),
                            onChanged: (value) {
                              String? amount = value;

                              ingredientListNotifier.editAmount(
                                  ingredientList[index].id, amount);

                              ///テスト用
                              // print("-------amount------");
                              // for (int i = 0; i < ingredientList.length; i++) {
                              //   print(ingredientList[i].id +
                              //       ":" +
                              //       ingredientList[i].name +
                              //       ":" +
                              //       ingredientList[i].amount.toString() +
                              //       ":" +
                              //       ingredientList[i].unit);
                              // }
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

                            ///テスト用
                            // print("--------unit-------");
                            // for (int i = 0; i < ingredientList.length; i++) {
                            //   print(ingredientList[i].id +
                            //       ":" +
                            //       ingredientList[i].name +
                            //       ":" +
                            //       ingredientList[i].amount.toString() +
                            //       ":" +
                            //       ingredientList[i].unit);
                            // }
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
              name: "",
              amount: "",
              unit: "個",
              // formState: GlobalKey<FormState>()
            );
            ingredientListNotifier.add(ingredient);
          },
          child: Text("追加"),
        )
      ],
    );
  }
}
