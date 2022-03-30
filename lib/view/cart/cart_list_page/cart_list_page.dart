import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/components/type_adapter/cart_checkbox.dart';
import 'package:recipe/view/add_cart_recipe_detail/add_cart_recipe_detail_page.dart';
import 'package:recipe/components/providers.dart';

import '../../../domain/cart.dart';
import 'cart_list_model.dart';

// レシピ一覧画面
class CartListPage extends ConsumerWidget {
  const CartListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CartListModel cartListModel = CartListModel();

    final recipeListInCartStream = ref.watch(recipeListInCartStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('カート'),
      ),
      body: Column(
        children: [
          Expanded(
            child: recipeListInCartStream.when(
                error: (error, stack) => Text('Error: $error'),
                loading: () => const CircularProgressIndicator(),
                data: (recipeListInCart) {
                  List<IngredientPerInCartRecipe>
                      ingredientPerInCartRecipeList = [];

                  for (var recipe in recipeListInCart) {
                    final ingredientList = ref.watch(
                        ingredientListStreamProviderFamily(recipe.recipeId!));
                    ingredientList.when(
                      error: (error, stack) => Text('Error: $error'),
                      loading: () => const CircularProgressIndicator(),
                      data: (ingredientList) {
                        List<IngredientPerInCartRecipe> addList =
                            cartListModel.createIngredientPerInCartRecipeList(
                                recipe, ingredientList);
                        for (var item in addList)
                          ingredientPerInCartRecipeList.add(item);
                      },
                    );
                  }

                  List<IngredientInCartPerRecipeList>
                      ingredientListInCartPerRecipeList =
                      cartListModel.createIngredientListInCartPerRecipeList(
                          ingredientPerInCartRecipeList);

                  return ListView.builder(
                      itemCount: ingredientListInCartPerRecipeList.length,
                      itemBuilder: (context, index) {
                        final ingredient =
                            ingredientListInCartPerRecipeList[index];
                        final id = ingredient.ingredientInCart.ingredientName +
                            ingredient.ingredientInCart.ingredientUnit;
                        return ValueListenableBuilder(
                            valueListenable: Hive.box('checkBox').listenable(),
                            builder: (context, Box box, widget) {
                              return CheckboxListTile(
                                title: Text(
                                    '${ingredient.ingredientInCart.ingredientName}'),
                                subtitle: Text(
                                    '${ingredient.ingredientInCart.ingredientTotalAmount}${ingredient.ingredientInCart.ingredientUnit}'),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: box.get(id, defaultValue: false),
                                onChanged: (bool) {
                                  box.put(id, bool);
                                  print('$id: $bool');
                                },
                                secondary: IconButton(
                                  icon: Icon(Icons.info_outline),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text(
                                              '${ingredientListInCartPerRecipeList[index].ingredientInCart.ingredientName}を使うレシピ'),
                                          contentPadding: EdgeInsets.zero,
                                          content: Container(
                                            width: double.maxFinite,
                                            height: 200,
                                            child: ListView.builder(
                                              itemCount:
                                                  ingredientListInCartPerRecipeList[
                                                          index]
                                                      .recipeForIngredientInCartList
                                                      .length,
                                              itemBuilder:
                                                  (context, recipeIndex) {
                                                final recipe =
                                                    ingredientListInCartPerRecipeList[
                                                                index]
                                                            .recipeForIngredientInCartList[
                                                        recipeIndex];
                                                return ListTile(
                                                  title: Text(
                                                      '${recipe.recipeName}'),
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
                                                    icon: Icon(
                                                        Icons.info_outline),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            fullscreenDialog:
                                                                false,
                                                            builder: (context) =>
                                                                AddBasketRecipeDetailPage(
                                                                    recipe
                                                                        .recipeId),
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
                              );
                            });
                      });
                }),
          ),
        ],
      ),
    );
  }
}
