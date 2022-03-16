import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe/providers.dart';

import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/view/add_basket_recipe_detail/add_basket_recipe_detail_page.dart';
import 'package:recipe/view/recipe_detail/recipe_detail_page.dart';
import 'package:recipe/view/recipe_list/recipe_list_model.dart';
import 'package:recipe/domain/recipe.dart';

// レシピ一覧画面
class AddBasketRecipeListPage extends ConsumerWidget {
  const AddBasketRecipeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeListStreamProvider);
    RecipeListModel recipeListModel = RecipeListModel();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.green,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'かごに追加するレシピを選択',
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ),
      body: recipes.when(
          error: (error, stack) => Text('Error: $error'),
          loading: () => const CircularProgressIndicator(),
          data: (recipes) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  final ingredients = ref.watch(
                      ingredientListStreamProviderFamily(recipe.recipeId!));
                  String outputIngredientText = '';

                  final procedures = ref.watch(
                      procedureListStreamProviderFamily(recipe.recipeId!));

                  ingredients.when(
                      data: (ingredient) {
                        recipe.ingredientList = ingredient;

                        outputIngredientText =
                            recipeListModel.toOutputIngredientText(ingredient);
                      },
                      error: (error, stack) => Text('Error: $error'),
                      loading: () => const CircularProgressIndicator());

                  procedures.when(
                      data: (procedure) {
                        recipe.procedureList = procedure;
                      },
                      error: (error, stack) => Text('Error: $error'),
                      loading: () => const CircularProgressIndicator());

                  return GestureDetector(
                    ///画面遷移
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) =>
                                AddBasketRecipeDetailPage(recipe.recipeId!),
                          ));
                    },

                    child: Card(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Hero(
                              tag: 'recipeName' + recipe.recipeId!,
                              child: Text(
                                recipe.recipeName.toString(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: SizedBox(
                                width: 200,
                                height: 120,
                                child: Hero(
                                  tag: 'recipeImage' + recipe.recipeId!,
                                  child: recipe.imageUrl != null
                                      ? recipe.imageUrl != ''
                                          ? Image.network(
                                              recipe.imageUrl!,
                                              errorBuilder: (c, o, s) {
                                                return const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                );
                                              },
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: Colors.grey[400],
                                              ),
                                              child: Icon(Icons
                                                  .add_photo_alternate_outlined),
                                            )
                                      : CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              outputIngredientText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(height: 50.0),
        shape: CircularNotchedRectangle(),
      ),
    );
  }
}
