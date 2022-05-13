import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:recipe/components/providers.dart';
import 'package:recipe/components/widgets/recipe_card_widget/recipe_card_widget.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/view/recipe/search_recipe/search_recipe_model.dart';

import '../recipe_detail/recipe_detail_page.dart';

// レシピ一覧画面
class SearchRecipePage extends ConsumerWidget {
  const SearchRecipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SearchRecipeModel searchRecipeModel = SearchRecipeModel();

    final recipes = ref.watch(recipeListStreamProvider);
    final recipeAndIngredientNameList =
        ref.watch(recipeAndIngredientNameListStreamProvider);
    final searchResultRecipeIdList =
        ref.watch(searchResultRecipeIdListProvider);
    final searchResultRecipeIdListNotifier =
        ref.watch(searchResultRecipeIdListProvider.notifier);

    final searchFunction = ref.watch(searchFunctionProvider);
    final searchFunctionNotifier = ref.watch(searchFunctionProvider.notifier);

    List<String> searchResultList = [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  fillColor: Theme.of(context).dividerColor,
                  filled: true,

                  /// TODO (after release)枠線消す
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'レシピ名、材料名で検索',
                ),
                onSubmitted: (searchWord) {
                  print('searchWord is $searchWord');

                  recipeAndIngredientNameList.when(
                      error: (error, stack) => Text('Error: $error'),
                      loading: () => const CircularProgressIndicator(),
                      data: (recipeNameAndIngredientNameList) {
                        searchResultRecipeIdListNotifier.state =
                            searchRecipeModel.searchRecipe(
                                searchWord, recipeNameAndIngredientNameList);
                      });
                },
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 24,
          )
        ],
      ),
      body: recipes.when(
          error: (error, stack) => Text('Error: $error'),
          loading: () => CircularProgressIndicator(),
          data: (recipes) {
            List<Recipe> outputRecipeList = [];
            // 検索画面起動時に、全レシピが表示される
            if (searchResultRecipeIdList == null) {
              outputRecipeList = recipes;
            } else {
              outputRecipeList = [];
              for (var searchResultRecipeId in searchResultRecipeIdList) {
                for (var recipe in recipes) {
                  if (recipe.recipeId == searchResultRecipeId) {
                    outputRecipeList.add(recipe);
                  }
                }
              }
            }
            return outputRecipeList.isEmpty == true
                ? Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        'レシピが見つかりませんでした。',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: outputRecipeList.length,
                        itemBuilder: (context, index) {
                          final outputRecipe = outputRecipeList[index];
                          return GestureDetector(
                            ///画面遷移
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    fullscreenDialog: false,
                                    builder: (context) => RecipeDetailPage(
                                        outputRecipe.recipeId!,
                                        'recipe_list_page'),
                                  ));
                            },
                            child: RecipeCardWidget(outputRecipe),
                          );
                        }),
                  );
          }),
    );
  }
}
