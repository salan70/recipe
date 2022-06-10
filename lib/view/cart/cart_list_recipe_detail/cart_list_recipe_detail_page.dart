import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/widgets/recipe_detail_widget/recipe_detail_widget.dart';

class CartListRecipeDetailPage extends ConsumerWidget {
  const CartListRecipeDetailPage({Key? key, required this.recipeId})
      : super(key: key);
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'レシピの詳細',
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            child: RecipeDetailWidget(recipeId: recipeId),
          ),
        ],
      ),
    );
  }
}
