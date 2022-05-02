import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/domain/recipe.dart';

class RecipeCardWidget extends ConsumerWidget {
  RecipeCardWidget(this.recipe);
  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  width: 200,
                  height: 120,
                  child: recipe.imageUrl != null
                      ? recipe.imageUrl != ''
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
                            )
                      : CircularProgressIndicator(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                child: Text(
                  recipe.recipeName.toString(),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
