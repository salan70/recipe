// outside
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// inside
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/providers.dart';

class IngredientListNotifier extends StateNotifier<List<Ingredient>> {
  IngredientListNotifier() : super([Ingredient(Uuid().v4(), "", 0, "")]);

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
                      Expanded(child: Text((index + 1).toString())),
                      Expanded(
                          child: TextField(
                        maxLines: null,
                        onChanged: (String value) {
                          ingredientList[index] = Ingredient(
                              ingredientList[index].id, value, 0, "");

                          ///テスト用
                          // for (int i = 0; i < proceduresList.length; i++) {
                          //   print(proceduresList[i].id.toString() +
                          //       ":" +
                          //       proceduresList[i].content);
                          // }
                          // print("------------------");
                        },
                      )),
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
            final Ingredient ingredient = Ingredient(id, "", 0, "");
            notifier.add(ingredient);
            print(id);
          },
          child: Text("追加"),
        )
      ],
    );
  }
}
