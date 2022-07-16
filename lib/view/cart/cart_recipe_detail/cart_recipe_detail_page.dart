import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe/components/widgets/recipe_detail_widget/recipe_detail_widget.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/recipe/update_recipe/update_recipe_page.dart';

class CartRecipeDetailPage extends ConsumerWidget {
  const CartRecipeDetailPage({Key? key, required this.recipeId})
      : super(key: key);

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipeProviderFamily(recipeId));

    return Scaffold(
      appBar: recipe.when(
        error: (error, stack) => AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('エラー'),
        ),
        loading: () => AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        data: (recipe) {
          return AppBar(
            elevation: 1,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            title: const Text(
              'レシピの詳細',
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateRecipePage(recipe: recipe),
                      fullscreenDialog: true,
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              )
            ],
          );
        },
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: recipe.when(
                  error: (error, stack) => Text('Error: $error'),
                  loading: () => const CircularProgressIndicator(),
                  data: (recipe) {
                    return RecipeDetailWidget(recipeId: recipeId);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 24.h,
            ),
          ],
        ),
      ),
    );
  }
}
