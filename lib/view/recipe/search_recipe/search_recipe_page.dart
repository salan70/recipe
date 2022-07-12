import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/recipe/search_recipe/search_recipe_model.dart';
import 'package:recipe/view/recipe/search_recipe_history/search_recipe_history_widget.dart';
import 'package:recipe/view/recipe/search_recipe_result/search_recipe_result_widget.dart';

class SearchRecipePage extends ConsumerWidget {
  const SearchRecipePage({Key? key, required this.searchWord})
      : super(key: key);

  final String searchWord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchRecipeModel = SearchRecipeModel();

    final recipeAndIngredientNameList =
        ref.watch(recipeAndIngredientListProvider);
    final searchResultListNotifier =
        ref.watch(searchResultListProvider.notifier);

    final isEntering = ref.watch(isEnteringProvider);
    final isEnteringNotifier = ref.watch(isEnteringProvider.notifier);

    final controller = TextEditingController(text: searchWord);
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            if (isEntering) {
              isEnteringNotifier.state = false;
              FocusScope.of(context).unfocus();
            } else {
              // var count = 0;
              // Navigator.popUntil(context, (_) => count++ >= 2);
              Navigator.of(context).pop();
            }
          },
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                // autofocus: isEntering のほうが良い？
                autofocus: isEntering,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'レシピ名、材料名で検索',
                  suffixIconConstraints:
                      BoxConstraints(maxHeight: 24.h, maxWidth: 24.w),
                ),
                onTap: () {
                  isEnteringNotifier.state = true;
                },
                //TODO 「✗(クリア)」関連の処理
                onSubmitted: (searchWord) {
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
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchRecipePage(
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
      body: isEntering
          ? const SearchRecipeHistoryWidget()
          : const SearchRecipeResultWidget(),
    );
  }
}
