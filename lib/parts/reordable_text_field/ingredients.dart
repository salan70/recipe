// outside
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

// inside
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/providers.dart';

class IngredientListNotifier extends StateNotifier<List<Ingredient>> {
  IngredientListNotifier() : super([Ingredient(Uuid().v4(), "", 0, "個")]);

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
}

class IngredientListWidget extends ConsumerWidget {
  const IngredientListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientList = ref.watch(ingredientListNotifierProvider);
    final notifier = ref.watch(ingredientListNotifierProvider.notifier);
    final unit = ref.watch(ingredientUnitProvider.notifier);

    return Column(
      children: [
        Builder(builder: (context) {
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) =>
                notifier.reorder(oldIndex, newIndex),
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
                      onTap: () => notifier.remove(ingredientList[index].id),
                    ),
                  ],
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration.collapsed(hintText: "ルッコラ"),
                        onChanged: (String value) {
                          String name = value;
                          ingredientList[index].name = name;

                          ///テスト用
                          print("--------name-------");
                          for (int i = 0; i < ingredientList.length; i++) {
                            print(ingredientList[i].id +
                                ":" +
                                ingredientList[i].name +
                                ":" +
                                ingredientList[i].amount.toString());
                          }
                        },
                      )),
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration.collapsed(hintText: "2000"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          double amount;

                          try {
                            amount = double.parse(value.toString());
                          } catch (exception) {
                            amount = 0;
                          }
                          ingredientList[index].amount = amount;

                          ///テスト用
                          print("-------amount------");
                          for (int i = 0; i < ingredientList.length; i++) {
                            print(ingredientList[i].id +
                                ":" +
                                ingredientList[i].name +
                                ":" +
                                ingredientList[i].amount.toString());
                          }
                        },
                      )),
                      Expanded(
                        child: DropdownButton<String>(
                          value: ingredientList[index].unit,
                          onChanged: (String? value) {
                            unit.state = value!;
                            ingredientList[index].unit = unit.state;
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
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          top: 8.0,
                          left: 16,
                        ),
                        child: Icon(Icons.drag_handle),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
        TextButton(
          onPressed: () {
            String id = Uuid().v4();
            final Ingredient ingredient = Ingredient(id, "", 0, "個");
            notifier.add(ingredient);
            print(id);
          },
          child: Text("追加"),
        )
      ],
    );
  }
}
