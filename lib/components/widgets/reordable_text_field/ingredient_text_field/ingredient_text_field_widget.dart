import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe/components/validation/validation.dart';
import 'package:recipe/components/widgets/reordable_text_field/ingredient_text_field/ingredient_text_field_model.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/state/ingredient_list/ingredient_list_provider.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/other/edit_ingredient_unit/edit_ingredient_unit_page.dart';
import 'package:uuid/uuid.dart';

class IngredientTextFieldWidget extends ConsumerWidget {
  const IngredientTextFieldWidget({Key? key, this.recipe}) : super(key: key);

  final Recipe? recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientList = ref.watch(ingredientListNotifierProvider);
    final ingredientListNotifier =
        ref.watch(ingredientListNotifierProvider.notifier);

    final Validations validation = Validations();

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
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (int index = 0; index < ingredientList.length; index++)
                Slidable(
                  key: ValueKey(ingredientList[index].id),
                  endActionPane: ActionPane(
                    extentRatio: 0.3,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                          borderRadius: BorderRadius.circular(10),
                          label: '削除',
                          backgroundColor: Theme.of(context).errorColor,
                          onPressed: (context) {
                            ingredientListNotifier
                                .remove(ingredientList[index].id);
                          })
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 6,
                              child: TextField(
                                controller: nameIsChanged == false
                                    ? TextEditingController(
                                        text: ingredientList[index].name)
                                    : null,
                                maxLength: 20,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  hintText: '材料名',
                                  counterText: '',
                                ),
                                onChanged: (String value) {
                                  ingredientListNotifier.editName(
                                      ingredientList[index].id, value);
                                  nameIsChangedNotifier.update((state) => true);
                                },
                              )),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                              flex: 2,
                              child: TextField(
                                controller: amountIsChanged == false
                                    ? TextEditingController(
                                        text: ingredientList[index]
                                            .amount
                                            .toString())
                                    : null,
                                keyboardType: TextInputType.datetime,
                                maxLength: 5,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText: '数量',
                                  counterText: '',
                                  errorText: validation.outputAmountErrorText(
                                      ingredientList[index].amount),
                                ),
                                onChanged: (value) {
                                  ingredientListNotifier.editAmount(
                                      ingredientList[index].id, value);
                                  amountIsChangedNotifier
                                      .update((state) => true);
                                },
                              )),
                          Expanded(
                            flex: 2,
                            child: ValueListenableBuilder(
                                valueListenable:
                                    IngredientUnitBoxes.getIngredientUnit()
                                        .listenable(),
                                builder: (context, box, widget) {
                                  final IngredientTextFieldModel
                                      _ingredientTextFieldModel =
                                      IngredientTextFieldModel();

                                  final _ingredientUnitList =
                                      _ingredientTextFieldModel
                                          .fetchIngredientUnitList();

                                  final String unitNameForTextButton =
                                      ingredientList[index].unit == null ||
                                              ingredientList[index].unit == ''
                                          ? '単位'
                                          : ingredientList[index].unit!;

                                  String _tmpUnitName = _ingredientUnitList[0];

                                  return TextButton(
                                      onPressed: () {
                                        showCupertinoModalPopup<Container>(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                height: 250.h,
                                                color: Theme.of(context)
                                                    .backgroundColor,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        TextButton(
                                                          child:
                                                              const Text('戻る'),
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                        ),
                                                        TextButton(
                                                            child: const Text(
                                                                '決定'),
                                                            onPressed: () {
                                                              ingredientListNotifier.editUnit(
                                                                  ingredientList[
                                                                          index]
                                                                      .id,
                                                                  _tmpUnitName);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }),
                                                      ],
                                                    ),
                                                    const Divider(),
                                                    Expanded(
                                                      child: CupertinoPicker(
                                                        backgroundColor: Theme
                                                                .of(context)
                                                            .backgroundColor,
                                                        looping: false,
                                                        itemExtent: 30,
                                                        children:
                                                            _ingredientUnitList
                                                                .map((unitName) =>
                                                                    new Text(
                                                                      unitName,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .onBackground,
                                                                      ),
                                                                    ))
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
                                      child: Text(
                                        '$unitNameForTextButton',
                                        overflow: TextOverflow.ellipsis,
                                      ));
                                }),
                          ),
                          Icon(Icons.drag_handle),
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      )
                    ],
                  ),
                ),
            ],
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () {
                  final Ingredient ingredient = Ingredient(
                    id: Uuid().v4(),
                    name: '',
                    amount: '',
                    unit: null,
                  );
                  if (!ingredientListNotifier.add(ingredient)) {
                    showDialog<AlertDialog>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('登録できる材料は30個までです。'),
                          actions: [
                            TextButton(
                              child: const Text('閉じる'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('追加'),
              ),
            ),
            Expanded(
              child: TextButton(
                  onPressed: () {
                    Navigator.push<MaterialPageRoute>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditIngredientUnitPage(),
                      ),
                    );
                  },
                  child: Text(
                    '単位を編集',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  )),
            ),
          ],
        )
      ],
    );
  }
}
