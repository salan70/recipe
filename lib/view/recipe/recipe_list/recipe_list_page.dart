import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe/components/widgets/recipe_card_widget/recipe_card_widget.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/recipe/add_recipe/add_recipe_page.dart';
import 'package:recipe/view/recipe/recipe_detail/recipe_detail_page.dart';
import 'package:recipe/view/setting/setting_top/setting_top_page.dart';

class RecipeListPage extends ConsumerWidget {
  const RecipeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.settings_rounded,
          ),
          onPressed: () {
            Navigator.push<MaterialPageRoute<dynamic>>(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingTopPage(),
              ),
            );
          },
        ),
        title: const Text(
          'レシピ一覧',
        ),
      ),
      body: recipes.when(
        error: (error, stack) => Text('Error: $error'),
        loading: () => const CircularProgressIndicator(),
        data: (recipes) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8).r,
            child: ListView(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return GestureDetector(
                      ///画面遷移
                      onTap: () {
                        Navigator.push<MaterialPageRoute<dynamic>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                              recipeId: recipe.recipeId!,
                              fromPageName: 'recipe_list_page',
                            ),
                          ),
                        );
                      },
                      child: RecipeCardWidget(recipe: recipe),
                    );
                  },
                ),
                SizedBox(
                  height: 100.h,
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.edit_note_rounded,
          size: 32.0.sp,
        ),
        onPressed: () {
          Navigator.push<MaterialPageRoute<dynamic>>(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecipePage(),
              fullscreenDialog: true,
            ),
          );
        },
      ),
    );
  }
}
