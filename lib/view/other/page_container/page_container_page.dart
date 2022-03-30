import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe/components/providers.dart';
import 'package:recipe/view/cart_list_page/cart_list_page.dart';
import 'package:recipe/view/recipe_list/recipe_list_page.dart';

import '../../add_cart_recipe_list/add_cart_recipe_list_page.dart';
import '../../add_recipe/add_recipe_page.dart';

class PageContainerPage extends ConsumerWidget {
  const PageContainerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPage = ref.watch(selectPageProvider);
    final selectedPageNotifier = ref.watch(selectPageProvider.notifier);

    final _pages = [
      RecipeListPage(),
      CartListPage(),
    ];

    return Scaffold(
      body: HawkFabMenu(
        body: _pages[selectedPage],
        icon: AnimatedIcons.list_view,
        fabColor: Colors.yellow,
        iconColor: Colors.green,
        items: [
          HawkFabMenuItem(
            label: 'カートの中身を変更',
            ontap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (context) => AddCartRecipeListPage(),
                  ));
            },
            icon: const Icon(Icons.add_shopping_cart),
          ),
          HawkFabMenuItem(
            label: 'アカウント',
            ontap: () {},
            icon: Icon(Icons.account_circle),
          ),
          HawkFabMenuItem(
            label: '設定',
            ontap: () {},
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: selectedPage == 0
          ? FloatingActionButton(
              child: Icon(
                Icons.add,
                size: 32.0,
              ),
              onPressed: () {
                if (selectedPage == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddRecipeScreen(),
                        fullscreenDialog: true,
                      ));
                }
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.menu_book_rounded,
                color: selectedPage == 0
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
              onPressed: () {
                selectedPageNotifier.state = 0;
              },
            ),
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: selectedPage == 1
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
              onPressed: () {
                selectedPageNotifier.state = 1;
              },
            ),
          ],
          // type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
