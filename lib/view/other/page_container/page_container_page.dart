import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/buy_list/buy_list_page/buy_list_page.dart';
import 'package:recipe/view/cart/cart_list_page.dart';
import 'package:recipe/view/other/page_container/page_container_model.dart';
import 'package:recipe/view/recipe/add_cart_recipe_list/add_cart_recipe_list_page.dart';
import 'package:recipe/view/recipe/recipe_list/recipe_list_page.dart';
import 'package:recipe/view/recipe/search_recipe/search_recipe_page.dart';
import 'package:recipe/view/setting/setting_top/setting_top_page.dart';

class PageContainerPage extends ConsumerWidget {
  const PageContainerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPage = ref.watch(selectPageProvider);
    final selectedPageNotifier = ref.watch(selectPageProvider.notifier);

    final user = ref.watch(userStateNotifierProvider);

    final pages = [
      const RecipeListPage(),
      CartListPage(),
      const BuyListPage(),
    ];

    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        selectedFontSize: 12.sp,
        onTap: (int index) {
          selectedPageNotifier.state = index;
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_rounded,
            ),
            label: 'レシピ',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart_rounded,
            ),
            label: 'カート',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_box_rounded,
            ),
            label: '買い物リスト',
          ),
        ],
      ),
    );
  }

  Future<void> _addOtherCartItemDialog(
    BuildContext context,
    User user,
  ) {
    final pageContainerModel = PageContainerModel(user: user);
    var title = '';
    var subTitle = '';

    return showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('カートにアイテムを追加'),
          content: SizedBox(
            height: 160.h,
            width: 300.w,
            child: Column(
              children: [
                SizedBox(
                  height: 8.h,
                ),
                TextField(
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'アイテム名 (必須)',
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                TextField(
                  textInputAction: TextInputAction.done,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: '詳細',
                  ),
                  onChanged: (value) {
                    subTitle = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                await EasyLoading.show(status: 'loading...');
                if (title == '') {
                  await EasyLoading.showError(
                    'タイトルの入力は必須です。',
                  );
                } else {
                  final errorText = await pageContainerModel.addOtherCartItem(
                    title,
                    subTitle,
                  );
                  if (errorText == null) {
                    Navigator.of(context).pop();
                    await EasyLoading.showSuccess(
                      '$titleを追加しました',
                    );
                  } else {
                    await EasyLoading.showError(
                      errorText,
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
