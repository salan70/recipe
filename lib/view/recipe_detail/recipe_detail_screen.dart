import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/providers.dart';
import 'package:recipe/domain/recipe.dart';

class RecipeDetailScreen extends ConsumerWidget {
  RecipeDetailScreen(this.recipe);
  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authControllerState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Center(
          child: Hero(
            tag: 'recipeName' + recipe.recipeId!,
            child: Text(
              recipe.recipeName!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.check))
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: double.infinity,
        child: ListView(
          children: [
            SizedBox(height: 20),
            // 画像
            SizedBox(
              height: 250,
              child: recipe.imageUrl != ""
                  ? Hero(
                      tag: 'recipeImage' + recipe.recipeId!,
                      child: Image.network(recipe.imageUrl!))
                  : Container(
                      color: Colors.blueGrey,
                    ),
            ),
            // 評価
            Center(
                child: RatingBar.builder(
              ignoreGestures: true,
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
              onRatingUpdate: (rating) {},
            )),

            // 材料
            Column(
              children: [
                Row(children: [
                  Text("材料"),
                  SizedBox(width: 10),
                  Text(
                    recipe.forHowManyPeople.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("人分"),
                ]),
                ListView.builder(
                  itemCount: recipe.ingredientList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Text(recipe.ingredientList![index].name.toString()),
                        Text(recipe.ingredientList![index].amount.toString()),
                        Text(recipe.ingredientList![index].unit.toString()),
                      ],
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ],
            ),
            SizedBox(height: 20),

            // 手順
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("手順"),
                ),
                ListView.builder(
                  itemCount: recipe.procedureList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Text(index.toString()),
                        Text(recipe.procedureList![index].content.toString()),
                      ],
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ],
            ),
            SizedBox(height: 20),
            // メモ
            Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("メモ"),
                  ),
                  Container(
                      child: recipe.recipeMemo != null
                          ? Text(recipe.recipeMemo!)
                          : Text('')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
