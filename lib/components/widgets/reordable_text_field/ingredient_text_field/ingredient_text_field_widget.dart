import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

    final validation = Validations();

    final nameIsChanged = ref.watch(nameIsChangedProvider);
    final nameIsChangedNotifier = ref.watch(nameIsChangedProvider.notifier);

    final amountIsChanged = ref.watch(nameIsChangedProvider);
    final amountIsChangedNotifier = ref.watch(nameIsChangedProvider.notifier);

    return Column(
      children: [
        Builder(
          builder: (context) {
            return ReorderableListView(
              onReorder: ingredientListNotifier.reorder,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (int index = 0; index < ingredientList.length; index++)
                  Slidable(
                    key: ValueKey(ingredientList[index].id),
                    startActionPane: ActionPane(
                      extentRatio: 0.3,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          icon: FontAwesomeIcons.clover,
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Theme.of(context).dividerColor,
                          onPressed: (context) {
                            ingredientListNotifier.editSymbol(
                              ingredientList[index].id,
                              'clover',
                            );
                          },
                        ),
                        SlidableAction(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          icon: FontAwesomeIcons.diamond,
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                          backgroundColor: Theme.of(context).dividerColor,
                          onPressed: (context) {
                            ingredientListNotifier.editSymbol(
                              ingredientList[index].id,
                              'diamond',
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
                          label: '削除',
                          backgroundColor: Theme.of(context).errorColor,
                          onPressed: (context) {
                            ingredientListNotifier
                                .remove(ingredientList[index].id);
                          },
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ingredientList[index].symbol == 'clover'
                                ? SizedBox(
                                    width: 24.w,
                                    child: FaIcon(
                                      FontAwesomeIcons.clover,
                                      size: 16.sp,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : ingredientList[index].symbol == 'diamond'
                                    ? SizedBox(
                                        width: 24.w,
                                        child: FaIcon(
                                          FontAwesomeIcons.diamond,
                                          size: 16.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      )
                                    : SizedBox(
                                        width: 20.w,
                                      ),
                            Expanded(
                              flex: 6,
                              child: TextField(
                                controller: nameIsChanged == false
                                    ? TextEditingController(
                                        text: ingredientList[index].name,
                                      )
                                    : null,
                                maxLength: 20,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  hintText: '材料名',
                                  counterText: '',
                                ),
                                onChanged: (String value) {
                                  ingredientListNotifier.editName(
                                    ingredientList[index].id,
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
                                controller: amountIsChanged == false
                                    ? TextEditingController(
                                        text: ingredientList[index]
                                            .amount
                                            .toString(),
                                      )
                                    : null,
                                keyboardType: TextInputType.datetime,
                                maxLength: 5,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText: '数量',
                                  counterText: '',
                                  errorText: validation.outputAmountErrorText(
                                    ingredientList[index].amount,
                                  ),
                                ),
                                onChanged: (value) {
                                  ingredientListNotifier.editAmount(
                                    ingredientList[index].id,
                                    value,
                                  );
                                  amountIsChangedNotifier
                                      .update((state) => true);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: ValueListenableBuilder(
                                valueListenable:
                                    IngredientUnitBoxes.getIngredientUnit()
                                        .listenable(),
                                builder: (context, box, widget) {
                                  final ingredientTextFieldModel =
                                      IngredientTextFieldModel();

                                  final ingredientUnitList =
                                      ingredientTextFieldModel
                                          .fetchIngredientUnitList();

                                  final unitNameForTextButton =
                                      ingredientList[index].unit == null ||
                                              ingredientList[index].unit == ''
                                          ? '単位'
                                          : ingredientList[index].unit!;

                                  var selectedUnitName = ingredientUnitList[0];

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
                                                      child: const Text('戻る'),
                                                      onPressed: () =>
                                                          Navigator.of(
                                                        context,
                                                      ).pop(),
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                        '決定',
                                                      ),
                                                      onPressed: () {
                                                        ingredientListNotifier
                                                            .editUnit(
                                                          ingredientList[index]
                                                              .id,
                                                          selectedUnitName,
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
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .backgroundColor,
                                                    itemExtent: 30,
                                                    children: ingredientUnitList
                                                        .map(
                                                          (unitName) => Text(
                                                            unitName,
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                context,
                                                              )
                                                                  .colorScheme
                                                                  .onBackground,
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                    onSelectedItemChanged:
                                                        (index) {
                                                      selectedUnitName =
                                                          ingredientUnitList[
                                                              index];
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      unitNameForTextButton,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Icon(
                              Icons.drag_handle,
                            ),
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
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditIngredientUnitPage(),
                    ),
                  );
                },
                child: Text(
                  '単位を編集',
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
