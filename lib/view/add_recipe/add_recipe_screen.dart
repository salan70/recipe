import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/parts/reordable_text_field/procedures.dart';
import 'package:recipe/parts/reordable_text_field/ingredients.dart';
import 'package:recipe/providers.dart';
import 'package:recipe/view/recipe_list/recipe_list_screen.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:recipe/view/add_recipe/add_redipe_model.dart';
import 'package:uuid/uuid.dart';

class AddRecipeScreen extends ConsumerWidget {
  final AddRecipeModel addRecipeModel = AddRecipeModel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proceduresList = ref.watch(procedureListNotifierProvider);

    String? recipeName;
    String? recipeMemo;
    double? recipeGrade = 3.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Center(
          child: TextField(
            decoration: InputDecoration.collapsed(hintText: "料理名"),
            onChanged: (value) {
              recipeName = value;
              // Providerから値を更新
              // recipeName.state = value;
            },
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: double.infinity,
        child: ListView(
          children: [
            // 画像
            Container(
              height: 250,
              margin: EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[400],
              ),
              child: Icon(Icons.add_photo_alternate_outlined),
            ),
            // 評価
            Container(
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
                recipeGrade = rating;
              },
            )),

            // 材料
            // 手順
            Container(
              child: ProceduresListWidget(),
            ),
            // メモ
            Container(
              color: Colors.grey,
              child: Column(
                children: [
                  Container(
                    child: Text("メモ"),
                  ),
                  TextField(
                    decoration:
                        InputDecoration.collapsed(hintText: "fill out here"),
                    maxLines: null,
                    onChanged: (value) {
                      recipeMemo = value;

                      // Providerから値を更新
                      // context.read(recipeMemoProvider).state = value;
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                print("===追加===");
                Recipe recipe = Recipe(recipeName, recipeGrade, recipeMemo);
                addRecipeModel.addRecipe(recipe, proceduresList);

                //テスト用
                // for (int i = 0; i < proceduresList.length; i++) {
                //   print(proceduresList[i].id.toString() +
                //       ":" +
                //       proceduresList[i].content);
                // }
                // print("=========");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeListPage(),
                      fullscreenDialog: true,
                    ));
              },
              child: Text("追加"),
            ),
          ],
        ),
      ),
    );
  }
}
