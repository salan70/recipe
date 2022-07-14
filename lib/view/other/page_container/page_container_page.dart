import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:recipe/view/buy_list/buy_list/buy_list_page.dart';
import 'package:recipe/view/cart/cart_list_page.dart';
import 'package:recipe/view/recipe/recipe_list/recipe_list_page.dart';

class PageContainerPage extends ConsumerWidget {
  const PageContainerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = [
      const RecipeListPage(),
      CartListPage(),
      const BuyListPage(),
    ];

    return Scaffold(
      body: PersistentTabView(
        context,
        screens: pages,
        selectedTabScreenContext: (context) {
          if (context != null) {}
        },
        navBarStyle: NavBarStyle.simple,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        decoration: NavBarDecoration(
          border: Border(
            top: BorderSide(
              width: 0.1,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        items: [
          PersistentBottomNavBarItem(
            icon: const Icon(
              Icons.menu_book_rounded,
            ),
            inactiveIcon: const Icon(
              Icons.menu_book_rounded,
            ),
            title: 'レシピ',
            textStyle: TextStyle(
              fontSize: 10.sp,
            ),
            activeColorPrimary: Theme.of(context).primaryColor,
            inactiveColorPrimary: Theme.of(context).disabledColor,
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            inactiveIcon: const Icon(
              Icons.shopping_cart_outlined,
            ),
            title: 'カート',
            textStyle: TextStyle(
              fontSize: 10.sp,
            ),
            activeColorPrimary: Theme.of(context).primaryColor,
            inactiveColorPrimary: Theme.of(context).disabledColor,
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(
              Icons.check_box,
            ),
            inactiveIcon: const Icon(
              // text snippet, article, description, restaurant
              Icons.check_box_outlined,
            ),
            title: '買い物リスト',
            textStyle: TextStyle(
              fontSize: 10.sp,
            ),
            activeColorPrimary: Theme.of(context).primaryColor,
            inactiveColorPrimary: Theme.of(context).disabledColor,
          ),
        ],
      ),
    );
  }
}
