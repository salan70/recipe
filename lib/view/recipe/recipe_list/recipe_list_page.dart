import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:recipe/components/providers.dart';
import 'package:recipe/view/recipe/recipe_list/recipe_list_model.dart';

import '../recipe_detail/recipe_detail_page.dart';

// レシピ一覧画面
class RecipeListPage extends ConsumerWidget {
  const RecipeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeListStreamProvider);
    RecipeListModel recipeListModel = RecipeListModel();

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          'レシピ一覧',
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
                            fullscreenDialog: false,
                            builder: (context) =>
                                RecipeDetailPage(recipe.recipeId!),
                          ));
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: SizedBox(
                                width: 200,
                                height: 120,
                                child: Hero(
                                  tag: 'recipeList recipeImage' +
                                      recipe.recipeId!,
                                  child: recipe.imageUrl != null
                                      ? recipe.imageUrl != ''
                                          ? Image.network(
                                              recipe.imageUrl!,
                                              errorBuilder: (c, o, s) {
                                                return const Icon(
                                                  Icons.error,
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
                            child: Hero(
                              tag: 'recipeList recipeName' + recipe.recipeId!,
                              child: Text(
                                recipe.recipeName.toString(),
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
