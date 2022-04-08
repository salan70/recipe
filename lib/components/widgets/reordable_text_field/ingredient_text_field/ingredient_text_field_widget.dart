import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:recipe/components/widgets/reordable_text_field/ingredient_text_field/ingredient_text_field_model.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:recipe/domain/recipe.dart';
import 'package:recipe/components/providers.dart';
import 'package:recipe/components/validation/validation.dart';

import '../../../../domain/type_adapter/ingredient_unit/ingredient_unit.dart';

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

class IngredientTextFieldWidget extends ConsumerWidget {
  const IngredientTextFieldWidget({Key? key, this.recipe}) : super(key: key);

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
                        child: ValueListenableBuilder(
                            valueListenable:
                                IngredientUnitBoxes.getIngredientUnit()
                                    .listenable(),
                            builder: (context, box, widget) {
                              IngredientTextFieldModel
                                  _ingredientTextFieldModel =
                                  IngredientTextFieldModel();
                              final _ingredientUnitList =
                                  _ingredientTextFieldModel
                                      .fetchIngredientUnitList();
                              String unitNameForTextButton =
                                  ingredientList[index].unit == null ||
                                          ingredientList[index].unit == ''
                                      ? '単位'
                                      : ingredientList[index].unit!;
                              String _tmpUnitName = _ingredientUnitList[0];

                              return TextButton(
                                  onPressed: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            //Pickerの高さを指定。指定しない場合はフルスクリーン。
                                            height: 250,
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    TextButton(
                                                      child: const Text('戻る'),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                    ),
                                                    TextButton(
                                                        child: const Text('決定'),
                                                        onPressed: () {
                                                          ingredientListNotifier
                                                              .editUnit(
                                                                  ingredientList[
                                                                          index]
                                                                      .id,
                                                                  _tmpUnitName);
                                                          Navigator.of(context)
                                                              .pop();
                                                        }),
                                                  ],
                                                ),
                                                const Divider(),
                                                Expanded(
                                                  child: CupertinoPicker(
                                                    looping: false,
                                                    itemExtent: 30,
                                                    children:
                                                        _ingredientUnitList
                                                            .map((unitName) =>
                                                                new Text(
                                                                    unitName))
                                                            .toList(),
                                                    onSelectedItemChanged:
                                                        (index) {
                                                      _tmpUnitName =
                                                          _ingredientUnitList[
                                                              index];
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Text('$unitNameForTextButton'));
                            }),
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
              unit: null,
            );
            ingredientListNotifier.add(ingredient);
          },
          child: Text("追加"),
        )
      ],
    );
  }
}