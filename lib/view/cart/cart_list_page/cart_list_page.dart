import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/view/cart/cart_list_page/ingredient_tab/ingredient_tab_widget.dart';
import 'package:recipe/view/cart/cart_list_page/recip_tab/recipe_tab_widget.dart';

class CartListPage extends ConsumerWidget {
  const CartListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'カート',
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColorDark,
            tabs: <Widget>[
              Tab(
                child: Text(
                  '材料',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              Tab(
                child: Text(
                  'レシピ',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            IngredientTabWidget(), // 材料タブ
            RecipeTabWidget(), // レシピタブ
          ],
        ),
      ),
    );
  }
}
