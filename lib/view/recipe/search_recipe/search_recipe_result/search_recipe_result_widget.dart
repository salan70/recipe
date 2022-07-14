import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe/components/widgets/recipe_card_widget/recipe_card_widget.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/recipe/recipe_detail/recipe_detail_page.dart';

class SearchRecipeResultWidget extends ConsumerWidget {
  const SearchRecipeResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeListProvider);
    final searchResultList = ref.watch(searchResultListProvider);

    return recipes.when(
      error: (error, stack) => Text('Error: $error'),
      loading: () => const CircularProgressIndicator(),
      data: (recipes) {
        var outputRecipeList = <Recipe>[];
        // 検索画面起動時に、全レシピが表示される
        outputRecipeList = [];
        for (final searchResultRecipeId in searchResultList!) {
          for (final recipe in recipes) {
            if (recipe.recipeId == searchResultRecipeId) {
              outputRecipeList.add(recipe);
            }
          }
        }

        return outputRecipeList.isEmpty == true
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 32).r,
                child: Text(
                  'レシピが見つかりませんでした。',
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8).r,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: outputRecipeList.length,
                  itemBuilder: (context, index) {
                    final outputRecipe = outputRecipeList[index];
                    return GestureDetector(
                      ///画面遷移
                      onTap: () {
                        Navigator.push<MaterialPageRoute<dynamic>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                              recipeId: outputRecipe.recipeId!,
                              fromPageName: 'recipe_list_page',
                            ),
                          ),
                        );
                      },
                      child: RecipeCardWidget(recipe: outputRecipe),
                    );
                  },
                ),
              );
      },
    );
  }
}
