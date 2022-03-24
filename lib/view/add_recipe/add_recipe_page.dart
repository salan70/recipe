import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/components/parts/reordable_text_field/procedures.dart';
import 'package:recipe/components/parts/reordable_text_field/ingredients.dart';
import 'package:recipe/components/providers.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/view/add_recipe/add_recipe_model.dart';
import 'package:recipe/components/parts/validation/validation.dart';

class AddRecipeScreen extends ConsumerWidget {
  final Recipe recipe = Recipe(recipeGrade: 3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    final Validation validation = Validation();
    final AddRecipeModel addRecipeModel = AddRecipeModel(user: user!);

    final imageFile = ref.watch(imageFileNotifierProvider);
    final imageFileNotifier = ref.watch(imageFileNotifierProvider.notifier);

    final proceduresList = ref.watch(procedureListNotifierProvider);
    final ingredientList = ref.watch(ingredientListNotifierProvider);

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
                    print("===追加===");
                    Recipe addedRecipe = Recipe(
                        recipeName: recipe.recipeName,
                        recipeGrade: recipe.recipeGrade,
                        forHowManyPeople: recipe.forHowManyPeople,
                        recipeMemo: recipe.recipeMemo,
                        imageUrl: '',
                        imageFile: imageFile,
                        ingredientList: ingredientList,
                        procedureList: proceduresList);
                    bool addIsSuccess =
                        await addRecipeModel.addRecipe(addedRecipe);

                    if (addIsSuccess) {
                      Navigator.pop(context);
                      final snackBar = SnackBar(
                          content: const Text(
                        'レシピを追加しました',
                        textAlign: TextAlign.center,
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      final snackBar = SnackBar(
                          content: const Text(
                        'レシピの追加に失敗しました',
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
                child: imageFile != null
                    ? imageFile.path != ''
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            // child: Image.file(imageFile)
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              // color: Colors.grey[400],
                              color: Colors.red,
                            ),
                            child: Icon(Icons.add_photo_alternate_outlined),
                          )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          // color: Colors.grey[400],
                          color: Colors.blue,
                        ),
                        child: Icon(Icons.add_photo_alternate_outlined),
                      ),
              ),
              onTap: () async {
                print(imageFile);
                await imageFileNotifier.pickImage();
              },
            ),
            // 評価
            Center(
                child: RatingBar.builder(
              initialRating: 3,
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
                      width: 48,
                      child: TextField(
                        maxLength: 2,
                        decoration: InputDecoration(counterText: ''),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          recipe.forHowManyPeople = int.parse(value);
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
