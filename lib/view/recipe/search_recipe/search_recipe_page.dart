import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/recipe/search_recipe_resulut/search_recipe_result_model.dart';
import 'package:recipe/view/recipe/search_recipe_resulut/search_recipe_result_page.dart';

class SearchRecipePage extends ConsumerWidget {
  const SearchRecipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchRecipeModel = SearchRecipeResultModel();

    final recipeAndIngredientNameList =
        ref.watch(recipeAndIngredientNameListProvider);
    final searchResultListNotifier =
        ref.watch(searchResultListProvider.notifier);

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
                  contentPadding: const EdgeInsets.all(8),
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'レシピ名、材料名で検索',
                  suffixIconConstraints:
                      BoxConstraints(maxHeight: 24.h, maxWidth: 24.w),
                ),
                //TODO 「✗(クリア)」関連の処理

                onSubmitted: (searchWord) {
                  recipeAndIngredientNameList.when(
                    error: (error, stack) => Text('Error: $error'),
                    loading: () => const CircularProgressIndicator(),
                    data: (recipeNameAndIngredientNameList) {
                      searchResultListNotifier.state =
                          searchRecipeModel.searchRecipe(
                        searchWord,
                        recipeNameAndIngredientNameList,
                      );
                    },
                  );
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchRecipeResultPage(
                        searchWord: searchWord,
                      ),
                    ),
                  );
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).backgroundColor,
      ),
    );
  }
}
