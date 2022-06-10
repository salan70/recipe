import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/components/validation/validation.dart';
import 'package:recipe/components/widgets/edit_recipe_widget/edit_recipe_widget.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/image_file/image_file_provider.dart';
import 'package:recipe/state/ingredient_list/ingredient_list_provider.dart';
import 'package:recipe/state/procedure_list/procedure_list_provider.dart';
import 'package:recipe/view/recipe/update_recipe/update_recipe_model.dart';

class UpdateRecipePage extends ConsumerWidget {
  const UpdateRecipePage({Key? key, required this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validation = Validations();

    final user = ref.watch(userStateNotifierProvider);

    final updateRecipeModel = UpdateRecipeModel(user: user!);

    final imageFile = ref.watch(imageFileNotifierProvider);

    final procedureList = ref.watch(procedureListNotifierProvider);
    final ingredientList = ref.watch(ingredientListNotifierProvider);

    final originalRecipe = recipe;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Center(
          child: Text(
            'レシピを編集',
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final recipeErrorText =
                  validation.outputRecipeErrorText(recipe, ingredientList);

              /// レシピ追加の条件を満たしている場合の処理
              if (recipeErrorText == null) {
                await EasyLoading.show(status: 'loading...');
                final updatedRecipe = Recipe(
                  recipeName: recipe.recipeName,
                  recipeGrade: recipe.recipeGrade,
                  forHowManyPeople: recipe.forHowManyPeople,
                  recipeMemo: recipe.recipeMemo,
                  imageUrl: recipe.imageUrl,
                  imageFile: imageFile,
                  ingredientList: ingredientList,
                  procedureList: procedureList,
                );

                if (await updateRecipeModel.updateRecipe(
                  originalRecipe,
                  updatedRecipe,
                )) {
                  Navigator.pop(context);
                  await EasyLoading.showSuccess('${recipe.recipeName}を更新しました');
                } else {
                  await EasyLoading.showError('レシピの更新に失敗しました');
                }
              }

              /// レシピ追加の条件を満たしていない場合の処理
              else {
                await EasyLoading.showError(recipeErrorText);
              }
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: EditRecipeWidget(
        recipe: recipe,
      ),
    );
  }
}
