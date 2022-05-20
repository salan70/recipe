import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/widgets/edit_recipe_widget/edit_recipe_widget.dart';
import 'package:recipe/components/providers.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/components/validation/validation.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/view/recipe/update_recipe/update_recipe_model.dart';

class UpdateRecipePage extends ConsumerWidget {
  UpdateRecipePage(this.recipe);
  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Validations validation = Validations();

    final user = ref.watch(userStateNotifierProvider);

    final UpdateRecipeModel updateRecipeModel = UpdateRecipeModel(user: user!);

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
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Center(
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
                  EasyLoading.show(status: 'loading...');
                  Recipe updatedRecipe = Recipe(
                      recipeName: recipe.recipeName,
                      recipeGrade: recipe.recipeGrade,
                      forHowManyPeople: recipe.forHowManyPeople,
                      recipeMemo: recipe.recipeMemo,
                      imageUrl: recipe.imageUrl,
                      imageFile: imageFile,
                      ingredientList: ingredientList,
                      procedureList: procedureList);

                  if (await updateRecipeModel.updateRecipe(
                      originalRecipe, updatedRecipe)) {
                    Navigator.pop(context);
                    EasyLoading.showSuccess('${recipe.recipeName}を更新しました');
                  } else {
                    EasyLoading.showError('レシピの更新に失敗しました');
                  }
                }

                /// レシピ追加の条件を満たしていない場合の処理
                else {
                  EasyLoading.showError(recipeErrorText);
                }
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: EditRecipeWidget(recipe),
    );
  }
}
