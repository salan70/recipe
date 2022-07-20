import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/recipe/search_recipe/search_recipe_history/search_recipe_history_widget.dart';
import 'package:recipe/view/recipe/search_recipe/search_recipe_model.dart';
import 'package:recipe/view/recipe/search_recipe/search_recipe_result/search_recipe_result_widget.dart';

class SearchRecipePage extends ConsumerWidget {
  const SearchRecipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchRecipeModel = SearchRecipeModel();

    final recipeAndIngredientNameList =
        ref.watch(recipeAndIngredientListProvider);
    final searchResultListNotifier =
        ref.watch(searchResultListProvider.notifier);

    final isEntering = ref.watch(isEnteringProvider);
    final isEnteringNotifier = ref.watch(isEnteringProvider.notifier);

    final searchWordController = ref.watch(searchWordProvider);
    final searchWordControllerNotifier = ref.watch(searchWordProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchWordController,
                autofocus: isEntering,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'レシピ名、材料名で検索',
                  suffixIconConstraints:
                      BoxConstraints(maxHeight: 24.h, maxWidth: 24.w),
                  suffixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      searchWordControllerNotifier.state =
                          TextEditingController(text: '');
                      // searchWordController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                onTap: () {
                  isEnteringNotifier.state = true;
                },
                onSubmitted: (searchWord) {
                  searchWordControllerNotifier.state =
                      TextEditingController(text: searchWord);
                  isEnteringNotifier.state = false;

                  recipeAndIngredientNameList.when(
                    error: (error, stack) => Text('Error: $error'),
                    loading: () => const CircularProgressIndicator(),
                    data: (recipeAndIngredientList) {
                      searchResultListNotifier.state =
                          searchRecipeModel.searchRecipe(
                        searchWord,
                        recipeAndIngredientList,
                      );
                    },
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
      body: isEntering
          ? const SearchRecipeHistoryWidget()
          : const SearchRecipeResultWidget(),
    );
  }
}
