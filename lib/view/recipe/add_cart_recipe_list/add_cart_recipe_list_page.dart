import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/components/widgets/recipe_card_widget/recipe_card_widget.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:badges/badges.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:recipe/components/providers.dart';

import '../add_cart_recipe_detail/add_cart_recipe_detail_page.dart';
import 'add_cart_recipe_list_model.dart';

// レシピ一覧画面
class AddCartRecipeListPage extends ConsumerWidget {
  AddCartRecipeListPage({Key? key}) : super(key: key);

  final PanelController pc = PanelController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);

    final recipes = ref.watch(recipeListStreamProvider);

    final recipeForInCartListState =
        ref.watch(recipeForInCartListNotifierProvider);
    final recipeForInCartListStateNotifier =
        ref.watch(recipeForInCartListNotifierProvider.notifier);

    final recipeListInCartPanelIsOpen =
        ref.watch(recipeListInCartPanelIsOpenProvider);
    final recipeListInCartPanelIsOpenNotifier =
        ref.watch(recipeListInCartPanelIsOpenProvider.notifier);

    final stateIsChangedNotifier = ref.watch(stateIsChangedProvider.notifier);

    AddCartRecipeListModel addCartRecipeListModel =
        AddCartRecipeListModel(user: user!);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'かごに追加するレシピを選択',
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SlidingUpPanel(
            controller: pc,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
            minHeight: 20,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            body: ListView(
              children: [
                recipes.when(
                    error: (error, stack) => Text('Error: $error'),
                    loading: () => const CircularProgressIndicator(),
                    data: (recipes) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = recipes[index];

                              return GestureDetector(
                                ///画面遷移
                                onTap: () {
                                  stateIsChangedNotifier.state = false;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        fullscreenDialog: false,
                                        builder: (context) =>
                                            AddBasketRecipeDetailPage(
                                                recipe.recipeId!,
                                                'add_cart_recipe_list_page'),
                                      ));
                                },

                                child: RecipeCardWidget(recipe),
                              );
                            }),
                      );
                    }),
                SizedBox(
                  height: 240,
                )
              ],
            ),
            panelBuilder: (sc) => _recipeListInCartPanel(sc, pc, context, ref),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.only(left: 64, right: 24),
          height: 64.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 64,
                child: Container(
                    child: Badge(
                  padding: EdgeInsets.all(6),
                  badgeContent: SizedBox(
                      child: recipeForInCartListStateNotifier
                                  .calculateCountSum() >=
                              99
                          ? Text(
                              '99+',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )
                          : recipeForInCartListStateNotifier
                                      .calculateCountSum() >=
                                  10
                              ? Text(
                                  '${recipeForInCartListStateNotifier.calculateCountSum()}',
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  ' ${recipeForInCartListStateNotifier.calculateCountSum()} ',
                                  style: TextStyle(color: Colors.white),
                                )),
                  child: IconButton(
                    onPressed: () {
                      if (recipeListInCartPanelIsOpen) {
                        pc.close();
                      } else {
                        pc.open();
                      }
                      recipeListInCartPanelIsOpenNotifier.state =
                          !recipeListInCartPanelIsOpen;
                    },
                    icon: Icon(
                      Icons.shopping_cart_rounded,
                      size: 32,
                    ),
                  ),
                  position: BadgePosition.topEnd(top: 5, end: -10),
                )),
              ),
              SizedBox(
                width: 144,
                child: ElevatedButton(
                  onPressed: () async {
                    if (recipeForInCartListState.isEmpty != true) {
                      bool zeroIsInclude = addCartRecipeListModel
                          .checkCart(recipeForInCartListState);

                      if (zeroIsInclude) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('確認'),
                            content: Text('数量が0のレシピがありますがよろしいですか？'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: Text('いいえ'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  EasyLoading.show(status: 'loading...');
                                  final errorText = await addCartRecipeListModel
                                      .updateCountsInCart(
                                          recipeForInCartListState);
                                  if (errorText == null) {
                                    int popInt = 0;
                                    Navigator.popUntil(
                                        context, (_) => popInt++ >= 2);
                                    EasyLoading.showSuccess('カートを更新しました');
                                  } else {
                                    EasyLoading.dismiss();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('カート更新失敗'),
                                          content: Text('$errorText'),
                                          actions: [
                                            TextButton(
                                              child: Text('閉じる'),
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
                                child: Text('はい'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        EasyLoading.show(status: 'loading...');
                        final errorText = await addCartRecipeListModel
                            .updateCountsInCart(recipeForInCartListState);
                        if (errorText == null) {
                          Navigator.pop(context);
                          EasyLoading.showSuccess('カートを更新しました');
                        } else {
                          EasyLoading.dismiss();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('カート更新失敗'),
                                content: Text('$errorText'),
                                actions: [
                                  TextButton(
                                    child: Text('閉じる'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    }
                  },
                  child: Text(
                    '確定',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
      ),
    );
  }

  Widget _recipeListInCartPanel(ScrollController sc, PanelController pc,
      BuildContext context, WidgetRef ref) {
    final recipeListInCartStream = ref.watch(recipeListInCartStreamProvider);

    final recipeForInCartListState =
        ref.watch(recipeForInCartListNotifierProvider);
    final recipeForInCartListStateNotifier =
        ref.watch(recipeForInCartListNotifierProvider.notifier);

    final recipeListInCartPanelIsOpen =
        ref.watch(recipeListInCartPanelIsOpenProvider);
    final recipeListInCartPanelIsOpenNotifier =
        ref.watch(recipeListInCartPanelIsOpenProvider.notifier);

    final stateIsChanged = ref.watch(stateIsChangedProvider);
    final stateIsChangedNotifier = ref.watch(stateIsChangedProvider.notifier);

    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          padding: const EdgeInsets.only(right: 16, left: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
          ),
          child: Column(
            children: [
              // title
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 5,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'カートに入っているレシピ',
                          style: Theme.of(context).primaryTextTheme.headline5,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              Divider(),
              // body
              Container(
                child: recipeListInCartStream.when(
                    error: (error, stack) {
                      print('「recipeListInCartStream.when」でエラー： $error');
                      return Text('Error: $error');
                    },
                    loading: () => const CircularProgressIndicator(),
                    data: (recipesForInCartList) {
                      if (stateIsChanged == false) {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          recipeForInCartListStateNotifier
                              .getList(recipesForInCartList);
                        });
                      }

                      return Flexible(
                        child: ListView.builder(
                            controller: sc,
                            itemCount: recipeForInCartListState.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        recipeForInCartListState[index]
                                            .recipeName
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          '合計${recipeForInCartListState[index].forHowManyPeople! * recipeForInCartListState[index].countInCart!}人分',
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .subtitle2,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            stateIsChangedNotifier.state = true;
                                            if (recipeForInCartListState[index]
                                                    .countInCart! >
                                                0) {
                                              recipeForInCartListStateNotifier
                                                  .decrease(
                                                      recipeForInCartListState[
                                                              index]
                                                          .recipeId!);
                                            }
                                          },
                                          icon: recipeForInCartListState[index]
                                                      .countInCart! ==
                                                  0
                                              ? Icon(
                                                  Icons.remove_circle_outline)
                                              : Icon(Icons.remove_circle)),
                                      Text(
                                        '× ${recipeForInCartListState[index].countInCart!}',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle2,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            stateIsChangedNotifier.state = true;
                                            if (recipeForInCartListState[index]
                                                    .countInCart! <
                                                99) {
                                              recipeForInCartListStateNotifier
                                                  .increase(
                                                      recipeForInCartListState[
                                                              index]
                                                          .recipeId!);
                                            }
                                          },
                                          icon: recipeForInCartListState[index]
                                                      .countInCart! ==
                                                  99
                                              ? Icon(Icons.add_circle_outline)
                                              : Icon(Icons.add_circle))
                                    ],
                                  ),
                                ],
                              );
                            }),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
