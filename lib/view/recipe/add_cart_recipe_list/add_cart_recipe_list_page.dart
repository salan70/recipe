import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe/components/widgets/recipe_card_widget/recipe_card_widget.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:badges/badges.dart';

import 'package:recipe/components/providers.dart';

import '../add_cart_recipe_detail/add_cart_recipe_detail_page.dart';
import 'add_cart_recipe_list_model.dart';

// レシピ一覧画面
class AddCartRecipeListPage extends ConsumerWidget {
  AddCartRecipeListPage({Key? key}) : super(key: key);

  final ScrollController listViewController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);

    final recipes = ref.watch(recipeListStreamProvider);
    final recipeListInCartStream = ref.watch(recipeListInCartStreamProvider);

    final recipeForInCartListState =
        ref.watch(recipeForInCartListNotifierProvider);
    final recipeForInCartListStateNotifier =
        ref.watch(recipeForInCartListNotifierProvider.notifier);

    final stateIsChanged = ref.watch(stateIsChangedProvider);
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
      body: SnappingSheet(
        child: recipes.when(
            error: (error, stack) => Text('Error: $error'),
            loading: () => const CircularProgressIndicator(),
            data: (recipes) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                builder: (context) => AddBasketRecipeDetailPage(
                                    recipe.recipeId!,
                                    'add_cart_recipe_list_page'),
                              ));
                        },

                        child: RecipeCardWidget(recipe),
                      );
                    }),
              );
            }),

        ///snapingsheet
        lockOverflowDrag: true,
        snappingPositions: [
          SnappingPosition.factor(
            positionFactor: 0.0,
            snappingCurve: Curves.easeOutExpo,
            snappingDuration: Duration(seconds: 1),
            grabbingContentOffset: GrabbingContentOffset.top,
          ),
          SnappingPosition.factor(
            snappingCurve: Curves.elasticOut,
            snappingDuration: Duration(milliseconds: 1000),
            positionFactor: 0.7,
          ),
        ],
        grabbingHeight: 24,
        sheetAbove: null,
        grabbing: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.2)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 9),
                width: 100,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                color: Colors.grey[200],
                height: 2,
                margin: EdgeInsets.all(15).copyWith(top: 0, bottom: 0),
              )
            ],
          ),
        ),
        sheetBelow: SnappingSheetContent(
          draggable: true,
          childScrollController: listViewController,
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

                return Container(
                  color: Colors.white,
                  child: ListView.builder(
                      controller: listViewController,
                      itemCount: recipeForInCartListState.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                recipeForInCartListState[index]
                                                    .recipeId!);
                                      }
                                    },
                                    icon: recipeForInCartListState[index]
                                                .countInCart! ==
                                            0
                                        ? Icon(Icons.remove_circle_outline)
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
                                                recipeForInCartListState[index]
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
        ),
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
                  child: Icon(
                    Icons.shopping_cart_rounded,
                    size: 32,
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
                                  print('はい');
                                  EasyLoading.show(status: 'loading...');
                                  if (await addCartRecipeListModel
                                      .updateCountsInCart(
                                          recipeForInCartListState)) {
                                    int popInt = 0;
                                    Navigator.popUntil(
                                        context, (_) => popInt++ >= 2);
                                    EasyLoading.showSuccess('カートを更新しました');
                                  } else {
                                    ///TODO errorText出力するようにする？
                                    EasyLoading.showError('カートの更新に失敗しました');
                                  }
                                },
                                child: Text('はい'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        EasyLoading.show(status: 'loading...');
                        if (await addCartRecipeListModel
                            .updateCountsInCart(recipeForInCartListState)) {
                          Navigator.pop(context);
                          EasyLoading.showSuccess('カートを更新しました');
                        } else {
                          ///TODO errorText出力するようにする？
                          EasyLoading.showError('カートの更新に失敗しました');
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
}
