import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/components/widgets/recipe_card_widget/recipe_card_widget.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/view/recipe/recipe_detail/recipe_detail_page.dart';
import 'package:recipe/view/recipe/search_recipe/search_recipe_model.dart';

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
            width: 24.w,
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
                      padding: const EdgeInsets.only(top: 32).r,
                      child: Text(
                        'レシピが見つかりませんでした。',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8).r,
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
