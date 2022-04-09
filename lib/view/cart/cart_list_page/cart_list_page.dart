import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_tree/flutter_tree.dart';

import 'package:recipe/components/providers.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';
import 'package:recipe/view/recipe/add_cart_recipe_detail/add_cart_recipe_detail_page.dart';

import '../../../domain/cart.dart';
import 'cart_list_model.dart';

// レシピ一覧画面
class CartListPage extends ConsumerWidget {
  const CartListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CartListModel cartListModel = CartListModel();

    final recipeListInCartStream = ref.watch(recipeListInCartStreamProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'カート',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: '材料'),
              Tab(text: 'レシピ'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            /// 材料タブ
            ValueListenableBuilder(
                valueListenable: CartItemBoxes.getCartItems().listenable(),
                builder: (context, box, widget) {
                  return recipeListInCartStream.when(
                      error: (error, stack) => Text('Error: $error'),
                      loading: () => const CircularProgressIndicator(),
                      data: (recipeListInCart) {
                        List<IngredientPerInCartRecipe>
                            ingredientPerInCartRecipeList = [];

                        for (var recipe in recipeListInCart) {
                          final ingredientList = ref.watch(
                              ingredientListStreamProviderFamily(
                                  recipe.recipeId!));
                          ingredientList.when(
                            error: (error, stack) => Text('Error: $error'),
                            loading: () => const CircularProgressIndicator(),
                            data: (ingredientList) {
                              List<IngredientPerInCartRecipe> addList =
                                  cartListModel
                                      .createIngredientPerInCartRecipeList(
                                          recipe, ingredientList);
                              for (var item in addList)
                                ingredientPerInCartRecipeList.add(item);
                            },
                          );
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
                          color: Theme.of(context).dividerColor,
                          child: ListView(
                            children: [
                              _ingredientListCardWidget('buyList', buyList),
                              _ingredientListCardWidget(
                                  'notBuyList', notBuyList),
                              SizedBox(
                                height: 48,
                              ),
                            ],
                          ),
                        );
                      });
                }),

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
                      return Row(
                        children: [
                          Text(_recipe.recipeName!),
                          Text(
                              '合計${_recipe.countInCart! * _recipe.forHowManyPeople!}人分'),
                        ],
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _ingredientListCardWidget(
      String listType, List<IngredientInCartPerRecipeList> ingredientList) {
    CartListModel cartListModel = CartListModel();
    String _cardTitle = listType == 'buyList'
        ? '買うリスト'
        : listType == 'notBuyList'
            ? '買わないリスト'
            : '';
    String _slidableActionText = listType == 'buyList'
        ? '買わないリストへ'
        : listType == 'notBuyList'
            ? '買うリストへ'
            : '';
    return Column(
      children: [
        Container(
          child: Text(_cardTitle),
        ),
        Card(
          child: ListView.builder(
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
                      color: Colors.green,
                      iconWidget: Text(_slidableActionText),
                      onTap: () {
                        cartListModel.toggleIsNeed(
                          id,
                        );
                      },
                    ),
                  ],
                  child: CheckboxListTile(
                    title:
                        Text('${ingredient.ingredientInCart.ingredientName}'),
                    subtitle: Text(
                        '${ingredient.ingredientInCart.ingredientTotalAmount}${ingredient.ingredientInCart.ingredientUnit}'),
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
                            return AlertDialog(
                              title: Text(
                                  '${ingredient.ingredientInCart.ingredientName}を使うレシピ'),
                              contentPadding: EdgeInsets.zero,
                              content: Container(
                                width: double.maxFinite,
                                height: 200,
                                child: ListView.builder(
                                  itemCount: ingredient
                                      .recipeForIngredientInCartList.length,
                                  itemBuilder: (context, recipeIndex) {
                                    final recipe = ingredient
                                            .recipeForIngredientInCartList[
                                        recipeIndex];
                                    return ListTile(
                                      title: Text('${recipe.recipeName}'),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                              '${recipe.forHowManyPeople * recipe.countInCart}人分'),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text(
                                              '${recipe.ingredientAmount}${ingredient.ingredientInCart.ingredientUnit}'),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.info_outline),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                fullscreenDialog: false,
                                                builder: (context) =>
                                                    AddBasketRecipeDetailPage(
                                                        recipe.recipeId),
                                              ));
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
