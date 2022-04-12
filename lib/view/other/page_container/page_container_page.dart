import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/providers.dart';
import 'package:recipe/view/account/login_or_sign_up/login_or_sign_up_page.dart';
import 'package:recipe/view/recipe/add_recipe/add_recipe_page.dart';

import '../../../domain/recipe.dart';
import '../../cart/cart_list_page/cart_list_page.dart';
import '../../recipe/add_cart_recipe_list/add_cart_recipe_list_page.dart';
import '../../recipe/recipe_list/recipe_list_page.dart';

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
        /// HawkFar関連
        icon: AnimatedIcons.list_view,
        // fabColor: Theme.of(context).primaryColorLight,
        fabColor: Colors.white,
        iconColor: Theme.of(context).primaryColorDark,
        items: [
          HawkFabMenuItem(
            // color: Theme.of(context).primaryColorLight,
            color: Colors.white,
            label: 'カートの中身を変更',
            ontap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (context) => AddCartRecipeListPage(),
                  ));
            },
            icon: Icon(
              Icons.add_shopping_cart,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          HawkFabMenuItem(
            // color: Theme.of(context).primaryColorLight,
            color: Colors.white,
            label: 'アカウント',
            ontap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (context) => LoginOrSignUpPage(),
                  ));
            },
            icon: Icon(
              Icons.account_circle,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          HawkFabMenuItem(
            // color: Theme.of(context).primaryColorLight,
            color: Colors.white,
            label: '設定',
            ontap: () {},
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ],

        /// PersistentTabView関連
        body: _pages[selectedPage],
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
                        builder: (context) => AddRecipePage(),
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
                semanticLabel: 'レシピ',
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
                Icons.shopping_cart_rounded,
                color: selectedPage == 1
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
              onPressed: () {
                selectedPageNotifier.state = 1;
              },
            ),
          ],
        ),
      ),
    );
  }
}
