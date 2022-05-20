import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        title: Text(
          '材料の単位を編集',
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable: IngredientUnitBoxes.getIngredientUnit().listenable(),
          builder: (context, Box box, widget) {
            EditIngredientUnitModel ingredientUnitEditModel =
                EditIngredientUnitModel();
            final ingredientUnitList =
                ingredientUnitEditModel.fetchIngredientUnitList();
            String? addedUnit;
            String? errorTextWhenAdding;

            return SettingsList(sections: [
              SettingsSection(title: Text('追加'), tiles: [
                SettingsTile.navigation(
                  title: Text('単位を追加'),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onPressed: (context) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('単位を追加'),
                            content: TextField(
                              onChanged: (value) {
                                addedUnit = value;
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('キャンセル'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  EasyLoading.show(status: 'loading...');
                                  errorTextWhenAdding = ingredientUnitEditModel
                                      .outputAddError(addedUnit);
                                  if (errorTextWhenAdding == null) {
                                    ingredientUnitEditModel
                                        .addIngredientUnit(addedUnit!);
                                    Navigator.of(context).pop();
                                    EasyLoading.showSuccess(
                                        '$addedUnitを追加しました');
                                  } else {
                                    EasyLoading.showError(
                                        '$errorTextWhenAdding');
                                  }
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
              ]),
              SettingsSection(title: Text('単位'), tiles: [
                CustomSettingsTile(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),

                      /// (after release)TODO backgroundColorがpackageのdefaultと微妙に異なるが、一旦許容（後でできたら修正する）
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: ReorderableListView.builder(
                      onReorder: (oldIndex, newIndex) {
                        ingredientUnitEditModel.reorderIngredientUnitList(
                            oldIndex, newIndex);
                      },
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: ingredientUnitList.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          key: ValueKey(ingredientUnitList[index]),
                          actionPane: SlidableDrawerActionPane(),
                          secondaryActions: [
                            IconSlideAction(
                              color: Colors.red,
                              iconWidget: Text('削除'),
                              onTap: () async {
                                EasyLoading.show(status: 'loading...');
                                if (await ingredientUnitEditModel
                                    .deleteIngredientUnit(
                                        ingredientUnitList[index])) {
                                  EasyLoading.showSuccess(
                                      '${ingredientUnitList[index]}を削除しました');
                                } else {
                                  EasyLoading.showError('単位を1個未満にすることはできません。');
                                }
                              },
                            ),
                          ],
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                margin: EdgeInsetsDirectional.only(
                                  start: 17.25,
                                  end: 15,
                                ),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${ingredientUnitList[index]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      Icon(
                                        Icons.drag_handle_rounded,
                                        size: 21,
                                      ),
                                    ]),
                              ),
                              index + 1 < ingredientUnitList.length
                                  ? Divider(
                                      indent: 15,
                                      height: 0.3,
                                      color: Theme.of(context).dividerColor,
                                    )
                                  : Container(
                                      height: 0,
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ]),
              SettingsSection(title: Text('初期化'), tiles: [
                SettingsTile.navigation(
                  title: Text('単位を初期化'),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onPressed: (context) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('注意'),
                            content: Text('本当に単位を初期化しますか？'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('いいえ'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text('はい'),
                                onPressed: () async {
                                  EasyLoading.show(status: 'loading...');
                                  await ingredientUnitEditModel
                                      .deleteIngredientUnitList();

                                  Navigator.of(context).pop();
                                  EasyLoading.showSuccess('単位を初期化しました');
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
              ]),
            ]);
          }),
    );
  }
}
