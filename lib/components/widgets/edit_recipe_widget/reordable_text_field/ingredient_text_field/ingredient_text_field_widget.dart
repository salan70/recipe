import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe/components/validation/validation.dart';
import 'package:recipe/components/widgets/edit_recipe_widget/reordable_text_field/ingredient_text_field/ingredient_text_field_model.dart';
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

    return Column(
      children: [
        Builder(
          builder: (context) {
            return ReorderableListView(
              onReorder: ingredientListNotifier.reorder,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final ingredient in ingredientList)
                  Slidable(
                    key: ValueKey(ingredient.id),
                    startActionPane: ActionPane(
                      extentRatio: 0.3,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          label: 'a',
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Theme.of(context).dividerColor,
                          onPressed: (context) {
                            ingredientListNotifier.editSymbol(
                              ingredient.id,
                              'a',
                            );
                          },
                        ),
                        SlidableAction(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          label: 'b',
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                          backgroundColor: Theme.of(context).dividerColor,
                          onPressed: (context) {
                            ingredientListNotifier.editSymbol(
                              ingredient.id,
                              'b',
                            );
                          },
                        )
                      ],
                    ),
                    endActionPane: ActionPane(
                      extentRatio: 0.3,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          label: '??????',
                          backgroundColor: Theme.of(context).errorColor,
                          onPressed: (context) {
                            ingredientListNotifier.remove(ingredient.id);
                          },
                        )
                      ],
                    ),
                    child: _TextFieldRow(
                      ingredient: ingredient,
                    ),
                  ),
              ],
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Container()),
            Expanded(
              child: TextButton(
                onPressed: () {
                  final ingredient = Ingredient(
                    id: const Uuid().v4(),
                    symbol: null,
                    name: '',
                    amount: '',
                    unit: null,
                  );
                  if (!ingredientListNotifier.add(ingredient)) {
                    showDialog<AlertDialog>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('????????????????????????30??????????????????'),
                          actions: [
                            TextButton(
                              child: const Text('?????????'),
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
                child: const Text('??????'),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditIngredientUnitPage(),
                    ),
                  );
                },
                child: Text(
                  '???????????????',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _TextFieldRow extends ConsumerWidget {
  const _TextFieldRow({Key? key, required this.ingredient}) : super(key: key);

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validation = Validations();

    final ingredientListNotifier =
        ref.watch(ingredientListNotifierProvider.notifier);

    final nameIsChanged = ref.watch(nameIsChangedProvider);
    final nameIsChangedNotifier = ref.watch(nameIsChangedProvider.notifier);

    final amountIsChanged = ref.watch(nameIsChangedProvider);
    final amountIsChangedNotifier = ref.watch(nameIsChangedProvider.notifier);

    final unitButtonText = ingredient.unit == null ? '??????' : ingredient.unit!;

    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          width: 24.w,
          child: ingredient.symbol == 'a'
              ? Text(
                  'a',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : ingredient.symbol == 'b'
                  ? Text(
                      'b',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                  : null,
        ),
        Expanded(
          flex: 6,
          child: TextField(
            textInputAction: TextInputAction.next,
            controller: nameIsChanged == false
                ? TextEditingController(
                    text: ingredient.name,
                  )
                : null,
            maxLength: 20,
            decoration: const InputDecoration(
              hintText: '?????????',
              counterText: '',
            ),
            onChanged: (String value) {
              ingredientListNotifier.editName(
                ingredient.id,
                value,
              );
              nameIsChangedNotifier.update((state) => true);
            },
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Expanded(
          flex: 2,
          child: TextField(
            onSubmitted: (_) {
              showCupertinoModalPopup<Container>(
                context: context,
                builder: (context) {
                  return _UnitPicker(ingredient: ingredient);
                },
              );
            },
            controller: amountIsChanged == false
                ? TextEditingController(
                    text: ingredient.amount.toString(),
                  )
                : null,
            keyboardType: TextInputType.datetime,
            maxLength: 5,
            decoration: InputDecoration(
              hintText: '??????',
              counterText: '',
              errorText: validation.outputAmountErrorText(
                ingredient.amount,
              ),
            ),
            onChanged: (value) {
              ingredientListNotifier.editAmount(
                ingredient.id,
                value,
              );
              amountIsChangedNotifier.update((state) => true);
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: TextButton(
            onPressed: () {
              // textField???focus???????????????
              final currentScope = FocusScope.of(context);
              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                FocusManager.instance.primaryFocus!.unfocus();
              }

              showCupertinoModalPopup<Container>(
                context: context,
                builder: (context) {
                  return _UnitPicker(ingredient: ingredient);
                },
              );
            },
            child: Text(
              unitButtonText,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Icon(
          Icons.drag_handle,
        ),
      ],
    );
  }
}

class _UnitPicker extends ConsumerWidget {
  const _UnitPicker({Key? key, required this.ingredient}) : super(key: key);

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientListNotifier =
        ref.watch(ingredientListNotifierProvider.notifier);

    return ValueListenableBuilder(
      valueListenable: IngredientUnitBoxes.getIngredientUnit().listenable(),
      builder: (context, box, widget) {
        final ingredientTextFieldModel = IngredientTextFieldModel();

        final ingredientUnitList =
            ingredientTextFieldModel.fetchIngredientUnitList();

        var selectedUnit = ingredientUnitList[0];

        return Container(
          height: 250.h,
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('??????'),
                    onPressed: () => Navigator.of(
                      context,
                    ).pop(),
                  ),
                  TextButton(
                    child: const Text(
                      '??????',
                    ),
                    onPressed: () {
                      ingredientListNotifier.editUnit(
                        ingredient.id,
                        selectedUnit,
                      );
                      Navigator.of(
                        context,
                      ).pop();
                    },
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Theme.of(context).backgroundColor,
                  itemExtent: 30,
                  children: ingredientUnitList
                      .map(
                        (unitName) => Text(
                          unitName,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onBackground,
                          ),
                        ),
                      )
                      .toList(),
                  onSelectedItemChanged: (index) {
                    selectedUnit = ingredientUnitList[index];
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
