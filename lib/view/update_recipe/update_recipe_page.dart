import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/components/parts/reordable_text_field/procedures.dart';
import 'package:recipe/components/parts/reordable_text_field/ingredients.dart';
import 'package:recipe/view/recipe_detail/recipe_detail_page.dart';
import 'package:recipe/components/providers.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/components/parts/validation/validation.dart';
import 'package:recipe/repository/recipe_repository.dart';
import 'package:recipe/view/update_recipe/update_recipe_model.dart';

class UpdateRecipeScreen extends ConsumerWidget {
  UpdateRecipeScreen(this.recipe);
  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Validation validation = Validation();

    final user = ref.watch(authControllerProvider);

    final UpdateRecipeModel updateRecipeModel = UpdateRecipeModel(user: user!);

    final imageFile = ref.watch(imageFileNotifierProvider);
    final imageFileNotifier = ref.watch(imageFileNotifierProvider.notifier);

    final procedureList = ref.watch(procedureListNotifierProvider);
    final ingredientList = ref.watch(ingredientListNotifierProvider);

    final Recipe originalRecipe = recipe;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Center(
          child: TextField(
            controller: TextEditingController(text: recipe.recipeName),
            decoration: InputDecoration.collapsed(hintText: "料理名"),
            onChanged: (value) {
              recipe.recipeName = value;
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                if (recipe.recipeName == null) {
                  final snackBar = SnackBar(
                    content: const Text(
                      '料理名を入力してください',
                      textAlign: TextAlign.center,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (recipe.forHowManyPeople == null) {
                  final snackBar = SnackBar(
                      content: const Text(
                    '材料が何人分か入力してください',
                    textAlign: TextAlign.center,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (recipe.forHowManyPeople! < 1) {
                  final snackBar = SnackBar(
                      content: const Text(
                    '材料は1人分以上で入力してください',
                    textAlign: TextAlign.center,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  bool ingredientAmountIsOk = true;
                  for (int index = 0; index < ingredientList.length; index++) {
                    if (validation.errorText(ingredientList[index].amount) !=
                        null) {
                      // 材料の数量の再入力を求める
                      final snackBar = SnackBar(
                          content: const Text(
                        '材料の数量に不正な値があります',
                        textAlign: TextAlign.center,
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      print("false");
                      ingredientAmountIsOk = false;
                    }
                  }

                  if (ingredientAmountIsOk) {
                    print("===更新===");
                    print(ingredientList.length);
                    Recipe updatedRecipe = Recipe(
                        recipeName: recipe.recipeName,
                        recipeGrade: recipe.recipeGrade,
                        forHowManyPeople: recipe.forHowManyPeople,
                        recipeMemo: recipe.recipeMemo,
                        imageUrl: recipe.imageUrl,
                        imageFile: imageFile,
                        ingredientList: ingredientList,
                        procedureList: procedureList);

                    bool updateIsSuccess = await updateRecipeModel.updateRecipe(
                        originalRecipe, updatedRecipe);

                    if (updateIsSuccess) {
                      Navigator.pop(context);
                      final snackBar = SnackBar(
                          content: const Text(
                        'レシピを更新しました',
                        textAlign: TextAlign.center,
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      final snackBar = SnackBar(
                          content: const Text(
                        'レシピの更新に失敗しました',
                        textAlign: TextAlign.center,
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                }
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: double.infinity,
        child: ListView(
          children: [
            SizedBox(height: 20),
            // 画像
            GestureDetector(
              child: SizedBox(
                height: 250,
                child: imageFile.path != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(imageFile))
                    : recipe.imageUrl != '' && recipe.imageUrl != null
                        ? Image.network(
                            recipe.imageUrl!,
                            errorBuilder: (c, o, s) {
                              return const Icon(
                                Icons.error,
                              );
                            },
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.grey[400],
                            ),
                            child: Icon(Icons.add_photo_alternate_outlined),
                          ),
              ),
              onTap: () async {
                await imageFileNotifier.pickImage();
              },
            ),
            // 評価
            Center(
                child: RatingBar.builder(
              initialRating: recipe.recipeGrade!,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                recipe.recipeGrade = rating;
              },
            )),

            // 材料
            Column(
              children: [
                Row(children: [
                  Text("材料"),
                  SizedBox(width: 10),
                  SizedBox(
                      width: 32,
                      child: TextField(
                        controller: TextEditingController(
                            text: recipe.forHowManyPeople.toString()),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if (int.tryParse(value) != null) {
                            recipe.forHowManyPeople = int.parse(value);
                          }
                        },
                      )),
                  Text("人分"),
                ]),
                Container(
                  child: IngredientListWidget(),
                ),
              ],
            ),

            // 手順
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("手順"),
                ),
                ProceduresListWidget(),
              ],
            ),
            // メモ
            Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("メモ"),
                  ),
                  TextField(
                    controller: TextEditingController(text: recipe.recipeMemo),
                    maxLines: null,
                    onChanged: (value) {
                      recipe.recipeMemo = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
