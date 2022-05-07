import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:recipe/components/providers.dart';
import 'package:recipe/components/widgets/recipe_card_widget/recipe_card_widget.dart';

import '../recipe_detail/recipe_detail_page.dart';

// レシピ一覧画面
class SearchRecipePage extends ConsumerWidget {
  const SearchRecipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeListStreamProvider);
    final searchFunction = ref.watch(searchFunctionProvider);
    final searchFunctionNotifier = ref.watch(searchFunctionProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  fillColor: Theme.of(context).dividerColor,
                  filled: true,

                  /// TODO 枠線消す
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'レシピ名、材料名で検索',
                ),
                onSubmitted: (searchWord) {
                  print('searchWord is $searchWord');

                  /// TODO searchWordを渡して検索処理
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
            return Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return GestureDetector(
                      ///画面遷移
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: false,
                              builder: (context) => RecipeDetailPage(
                                  recipe.recipeId!, 'recipe_list_page'),
                            ));
                      },
                      child: RecipeCardWidget(recipe),
                    );
                  }),
            );
          }),
    );
  }
}
