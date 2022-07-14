import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/buy_list/buy_list/buy_list_page.dart';
import 'package:recipe/view/cart/cart_list_page.dart';
import 'package:recipe/view/recipe/recipe_list/recipe_list_page.dart';

class PageContainerPage extends ConsumerWidget {
  const PageContainerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 従来式
    // final selectedPage = ref.watch(selectPageProvider);
    // final selectedPageNotifier = ref.watch(selectPageProvider.notifier);

    final pages = [
      const RecipeListPage(),
      CartListPage(),
      const BuyListPage(),
    ];

    return Scaffold(
      body: PersistentTabView(
        context,
        screens: pages,
        navBarStyle: NavBarStyle.simple,
        items: [
          PersistentBottomNavBarItem(
            icon: const Icon(
              Icons.menu_book_rounded,
            ),
            title: 'レシピ',
            textStyle: TextStyle(
              fontSize: 10.sp,
            ),
            activeColorPrimary: Theme.of(context).primaryColor,
            inactiveColorPrimary: Theme.of(context).colorScheme.onBackground,
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(
              Icons.shopping_cart_rounded,
            ),
            title: 'カート',
            textStyle: TextStyle(
              fontSize: 10.sp,
            ),
            activeColorPrimary: Theme.of(context).primaryColor,
            inactiveColorPrimary: Theme.of(context).colorScheme.onBackground,
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(
              Icons.check_box_rounded,
            ),
            title: '買い物リスト',
            textStyle: TextStyle(
              fontSize: 10.sp,
            ),
            activeColorPrimary: Theme.of(context).primaryColor,
            inactiveColorPrimary: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
    );

    /// 従来式
    // return Scaffold(
    //   body: pages[selectedPage],
    //   bottomNavigationBar: BottomNavigationBar(
    //     currentIndex: selectedPage,
    //     selectedFontSize: 12.sp,
    //     onTap: (int index) {
    //       selectedPageNotifier.state = index;
    //     },
    //     items: const <BottomNavigationBarItem>[
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           Icons.menu_book_rounded,
    //         ),
    //         label: 'レシピ',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           Icons.shopping_cart_rounded,
    //         ),
    //         label: 'カート',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           Icons.check_box_rounded,
    //         ),
    //         label: '買い物リスト',
    //       ),
    //     ],
    //   ),
    // );
  }
}
