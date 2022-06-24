import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe/domain/type_adapter/ingredient_unit/ingredient_unit.dart';
import 'package:recipe/view/other/edit_ingredient_unit/edit_ingredient_unit_model.dart';
import 'package:settings_ui/settings_ui.dart';

class EditIngredientUnitPage extends ConsumerWidget {
  const EditIngredientUnitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '材料の単位を編集',
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: IngredientUnitBoxes.getIngredientUnit().listenable(),
        builder: (context, box, widget) {
          final ingredientUnitEditModel = EditIngredientUnitModel();
          final ingredientUnitList =
              ingredientUnitEditModel.fetchIngredientUnitList();

          String? addedUnit;
          String? errorTextWhenAdding;

          return SettingsList(
            sections: [
              SettingsSection(
                title: const Text('追加'),
                tiles: [
                  SettingsTile.navigation(
                    title: const Text('単位を追加'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onPressed: (context) {
                      showDialog<AlertDialog>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('単位を追加'),
                            content: TextField(
                              autofocus: true,
                              maxLength: 10,
                              onChanged: (value) {
                                addedUnit = value;
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('キャンセル'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  EasyLoading.show(status: 'loading...');
                                  errorTextWhenAdding = ingredientUnitEditModel
                                      .outputAddError(addedUnit);
                                  if (errorTextWhenAdding == null) {
                                    ingredientUnitEditModel
                                        .addIngredientUnit(addedUnit!);
                                    Navigator.of(context).pop();
                                    EasyLoading.showSuccess(
                                      '$addedUnitを追加しました',
                                    );
                                  } else {
                                    EasyLoading.showError(
                                      '$errorTextWhenAdding',
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('単位'),
                tiles: [
                  CustomSettingsTile(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        color: Theme.of(context).backgroundColor,
                      ),
                      child: ReorderableListView.builder(
                        onReorder:
                            ingredientUnitEditModel.reorderIngredientUnitList,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ingredientUnitList.length,
                        itemBuilder: (context, index) {
                          return Slidable(
                            key: ValueKey(ingredientUnitList[index]),
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
                                  onPressed: (context) async {
                                    await EasyLoading.show(
                                      status: 'loading...',
                                    );
                                    final deletedUnit =
                                        ingredientUnitList[index];

                                    if (await ingredientUnitEditModel
                                        .deleteIngredientUnit(
                                      ingredientUnitList[index],
                                    )) {
                                      await EasyLoading.showSuccess(
                                        '$deletedUnitを削除しました。',
                                      );
                                    } else {
                                      await EasyLoading.showError(
                                        '単位を1個未満にすることはできません。',
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 40.h,
                                  margin: const EdgeInsetsDirectional.only(
                                    start: 17.25,
                                    end: 15,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ingredientUnitList[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      Icon(
                                        Icons.drag_handle_rounded,
                                        size: 21.sp,
                                      ),
                                    ],
                                  ),
                                ),
                                index + 1 < ingredientUnitList.length
                                    ? Divider(
                                        indent: 15.w,
                                        height: 0.3.h,
                                        color: Theme.of(context).dividerColor,
                                      )
                                    : Container(
                                        height: 0.h,
                                      ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('初期化'),
                tiles: [
                  SettingsTile.navigation(
                    title: const Text('単位を初期化'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onPressed: (context) {
                      showDialog<AlertDialog>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('注意'),
                            content: const Text('本当に単位を初期化しますか？'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('いいえ'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text('はい'),
                                onPressed: () async {
                                  await EasyLoading.show(status: 'loading...');
                                  await ingredientUnitEditModel
                                      .deleteIngredientUnitList();

                                  Navigator.pop(context);
                                  await EasyLoading.showSuccess('単位を初期化しました');
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
