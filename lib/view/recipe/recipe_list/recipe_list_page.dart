import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:recipe/components/providers.dart';
import 'package:recipe/components/widgets/recipe_card_widget/recipe_card_widget.dart';
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
            return Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
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

                          outputIngredientText = recipeListModel
                              .toOutputIngredientText(ingredient);
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
                      child: RecipeCardWidget(recipe, 'recipe_list_page'),
                    );
                  }),
            );
          }),
    );
  }
}
