import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recipe/domain/recipe.dart';

class RecipeCardWidget extends ConsumerWidget {
  const RecipeCardWidget({Key? key, required this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8).r,
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 200.w,
                  height: 120.h,
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
                          : DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8).r,
                                color: Theme.of(context).dividerColor,
                              ),
                              child: const Icon(Icons.restaurant_rounded),
                            )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  recipe.recipeName!,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
