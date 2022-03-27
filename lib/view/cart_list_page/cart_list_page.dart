import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';

import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/view/add_cart_recipe_detail/add_cart_recipe_detail_page.dart';
import 'package:recipe/view/add_cart_recipe_list/add_cart_recipe_list_page.dart';
import 'package:recipe/view/add_recipe/add_recipe_page.dart';
import 'package:recipe/view/recipe_detail/recipe_detail_page.dart';
import 'package:recipe/view/recipe_list/recipe_list_model.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/components/providers.dart';

import '../../domain/cart.dart';
import '../add_cart_recipe_list/add_cart_recipe_list_page.dart';
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
      body: HawkFabMenu(
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
                          bool _isDone = false;
                          final ingredient =
                              ingredientListInCartPerRecipeList[index];
                          return CheckboxListTile(
                            title: Text(
                                '${ingredient.ingredientInCart.ingredientName}'),
                            subtitle: Text(
                                '${ingredient.ingredientInCart.ingredientTotalAmount}${ingredient.ingredientInCart.ingredientUnit}'),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _isDone,
                            onChanged: (bool) {},
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
                                          itemBuilder: (context, recipeIndex) {
                                            final recipe =
                                                ingredientListInCartPerRecipeList[
                                                            index]
                                                        .recipeForIngredientInCartList[
                                                    recipeIndex];
                                            return ListTile(
                                              title:
                                                  Text('${recipe.recipeName}'),
                                              subtitle: Text(
                                                  '${recipe.ingredientAmount}${ingredient.ingredientInCart.ingredientUnit}'),
                                              trailing: IconButton(
                                                icon: Icon(Icons.info_outline),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        fullscreenDialog: true,
                                                        builder: (context) =>
                                                            RecipeDetailPage(
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
                  }),
            ),
          ],
        ),
        icon: AnimatedIcons.list_view,
        fabColor: Colors.yellow,
        iconColor: Colors.green,
        items: [
          HawkFabMenuItem(
            label: 'カートにレシピを追加',
            ontap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => AddCartRecipeListPage(),
                  ));
            },
            icon: const Icon(Icons.add_shopping_cart),
          ),
          HawkFabMenuItem(
            label: 'Menu 2',
            ontap: () {},
            icon: Icon(Icons.comment),
          ),
          HawkFabMenuItem(
            label: 'Menu 3 (default)',
            ontap: () {},
            icon: Icon(Icons.add_a_photo),
          ),
        ],
      ),
    );
  }
}
