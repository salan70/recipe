import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/widgets/recipe_detail_widget/recipe_detail_widget.dart';

class CartListRecipeDetailPage extends ConsumerWidget {
  CartListRecipeDetailPage(this.recipeId);
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'レシピの詳細',
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: double.infinity,
        child: RecipeDetailWidget(recipeId),
      ),
    );
  }
}
