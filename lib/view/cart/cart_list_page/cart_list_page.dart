import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/providers.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';
import 'package:recipe/view/cart/cart_list_recipe_detail/cart_list_recipe_detail_page.dart';

import '../../../domain/cart.dart';
import 'cart_list_model.dart';

// レシピ一覧画面
class CartListPage extends ConsumerWidget {
  const CartListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CartListModel cartListModel = CartListModel();

    final recipeListInCartStream = ref.watch(recipeListInCartStreamProvider);
    final notBuyIngredientListIsOpen =
        ref.watch(notBuyIngredientListIsOpenProvider);
    final notBuyIngredientListIsOpenNotifier =
        ref.watch(notBuyIngredientListIsOpenProvider.notifier);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'カート',
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColorDark,
            tabs: <Widget>[
              Tab(
                  child: Text(
                '材料',
                style: Theme.of(context).primaryTextTheme.subtitle1,
              )),
              Tab(
                  child: Text(
                'レシピ',
                style: Theme.of(context).primaryTextTheme.subtitle1,
              )),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            /// 材料タブ
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: ValueListenableBuilder(
                  valueListenable: CartItemBoxes.getCartItems().listenable(),
                  builder: (context, box, widget) {
                    return recipeListInCartStream.when(
                        error: (error, stack) => Text('Error: $error'),
                        loading: () => const CircularProgressIndicator(),
                        data: (recipeListInCart) {
                          List<IngredientPerInCartRecipe>
                              ingredientPerInCartRecipeList = [];

                          for (var recipe in recipeListInCart) {
                            List<IngredientPerInCartRecipe> addList =
                                cartListModel
                                    .createIngredientPerInCartRecipeList(
                                        recipe);
                            for (var item in addList)
                              ingredientPerInCartRecipeList.add(item);
                          }

                          List<IngredientInCartPerRecipeList>
                              ingredientListInCartPerRecipeList = cartListModel
                                  .createIngredientListInCartPerRecipeList(
                                      ingredientPerInCartRecipeList);

                          List<IngredientInCartPerRecipeList> buyList =
                              cartListModel.createBuyList(
                                  ingredientListInCartPerRecipeList);
                          List<IngredientInCartPerRecipeList> notBuyList =
                              cartListModel.createNotBuyList(
                                  ingredientListInCartPerRecipeList);

                          return Container(
                            child: ListView(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                      '買う (${buyList.length})',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle1,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                _ingredientListCardWidget(
                                    context, 'buyList', buyList),
                                Divider(
                                  thickness: 1,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            '買わない (${notBuyList.length})',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .subtitle1,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        GestureDetector(
                                          child: notBuyIngredientListIsOpen ==
                                                  true
                                              ? Icon(Icons.expand_less_rounded)
                                              : Icon(Icons.expand_more_rounded),
                                          onTap: () {
                                            notBuyIngredientListIsOpenNotifier
                                                    .state =
                                                !notBuyIngredientListIsOpen;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                notBuyIngredientListIsOpen == true
                                    ? _ingredientListCardWidget(
                                        context, 'notBuyList', notBuyList)
                                    : Container(),
                                SizedBox(
                                  height: 48,
                                ),
                              ],
                            ),
                          );
                        });
                  }),
            ),

            /// レシピタブ
            recipeListInCartStream.when(
                error: (error, stack) => Text('Error: $error'),
                loading: () => const CircularProgressIndicator(),
                data: (recipeListInCart) {
                  final _recipeList = recipeListInCart;
                  return ListView.builder(
                    itemCount: _recipeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final _recipe = _recipeList[index];
                      return ListTile(
                        title: Text(
                          _recipe.recipeName!,
                          style: Theme.of(context).primaryTextTheme.subtitle1,
                        ),
                        subtitle: Text(
                            '${_recipe.countInCart! * _recipe.forHowManyPeople!}人分'),
                        trailing: IconButton(
                          icon: Icon(Icons.chevron_right_rounded),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  fullscreenDialog: false,
                                  builder: (context) =>
                                      CartListRecipeDetailPage(
                                          _recipe.recipeId!),
                                ));
                          },
                        ),
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _ingredientListCardWidget(BuildContext context, String listType,
      List<IngredientInCartPerRecipeList> ingredientList) {
    CartListModel cartListModel = CartListModel();
    String _slidableActionText = listType == 'buyList' ? '買わないリストへ' : '買うリストへ';
    Color _cardColor = listType == 'buyList'
        ? Theme.of(context).cardColor
        : Theme.of(context).dividerColor;

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: ingredientList.length,
        itemBuilder: (context, index) {
          final ingredient = ingredientList[index];
          final id = ingredient.ingredientInCart.ingredientName +
              ingredient.ingredientInCart.ingredientUnit;
          return Slidable(
            key: ValueKey(id),
            actionPane: SlidableDrawerActionPane(),
            actions: [
              IconSlideAction(
                color: Theme.of(context).dividerColor,
                iconWidget: Text(
                  _slidableActionText,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  cartListModel.toggleIsNeed(
                    id,
                  );
                },
              ),
            ],
            child: CheckboxListTile(
              title: Text(
                '${ingredient.ingredientInCart.ingredientName}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: cartListModel.getCartItem(id).isBought
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              subtitle: Text(
                '${ingredient.ingredientInCart.ingredientTotalAmount}${ingredient.ingredientInCart.ingredientUnit}',
                style: TextStyle(
                    decoration: cartListModel.getCartItem(id).isBought
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              value: cartListModel.getCartItem(id).isBought,
              onChanged: (isBought) {
                cartListModel.toggleIsBought(id, isBought!);
              },
              secondary: IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return _recipeListPerIngredientDialog(
                          context, ingredient);
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  Widget _recipeListPerIngredientDialog(
      BuildContext context, IngredientInCartPerRecipeList ingredient) {
    return AlertDialog(
      title: Text(
        '${ingredient.ingredientInCart.ingredientName}を使うレシピ',
        style: Theme.of(context).primaryTextTheme.headline5,
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: double.maxFinite,
        height: 200,
        child: ListView.builder(
          itemCount: ingredient.recipeForIngredientInCartList.length,
          itemBuilder: (context, recipeIndex) {
            final recipe =
                ingredient.recipeForIngredientInCartList[recipeIndex];
            return ListTile(
              title: Text(
                '${recipe.recipeName}',
                style: Theme.of(context).primaryTextTheme.subtitle1,
              ),
              subtitle: Row(
                children: [
                  Text('${recipe.forHowManyPeople * recipe.countInCart}人分'),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                      '${recipe.ingredientAmount}${ingredient.ingredientInCart.ingredientUnit}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.chevron_right_rounded),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: false,
                        builder: (context) =>
                            CartListRecipeDetailPage(recipe.recipeId),
                      ));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
