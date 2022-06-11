import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/cart/cart_list_recipe_detail/cart_list_recipe_detail_page.dart';

class RecipeTabWidget extends ConsumerWidget {
  const RecipeTabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeListInCart = ref.watch(recipeListInCartProvider);

    return recipeListInCart.when(
      error: (error, stack) => Text('Error: $error'),
      loading: () => const CircularProgressIndicator(),
      data: (recipeListInCart) {
        final recipeList = recipeListInCart;
        return ListView.builder(
          itemCount: recipeList.length,
          itemBuilder: (BuildContext context, int index) {
            final recipe = recipeList[index];
            return ListTile(
              title: Text(
                recipe.recipeName!,
                style: Theme.of(context).primaryTextTheme.subtitle1,
              ),
              subtitle: Text(
                '${recipe.countInCart! * recipe.forHowManyPeople!}人分',
                style: Theme.of(context).primaryTextTheme.caption,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: () {
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartListRecipeDetailPage(
                        recipeId: recipe.recipeId!,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
