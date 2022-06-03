import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/components/widgets/recipe_card_widget/recipe_card_widget.dart';
import 'package:recipe/view/recipe/recipe_detail/recipe_detail_page.dart';

class RecipeListPage extends ConsumerWidget {
  const RecipeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'レシピ一覧',
        ),
      ),
      body: recipes.when(
          error: (error, stack) => Text('Error: $error'),
          loading: () => CircularProgressIndicator(),
          data: (recipes) {
            return Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8).r,
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
