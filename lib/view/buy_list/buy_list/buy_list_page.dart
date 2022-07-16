import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/view/buy_list/buy_list/buy_list_model.dart';
import 'package:recipe/view/buy_list/ingredient_tab/ingredient_tab_widget.dart';
import 'package:recipe/view/setting/setting_top/setting_top_page.dart';

class BuyListPage extends ConsumerWidget {
  const BuyListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.settings_rounded,
          ),
          onPressed: () {
            Navigator.push<MaterialPageRoute<dynamic>>(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingTopPage(),
              ),
            );
          },
        ),
        title: const Text(
          'カート',
        ),
      ),
      body: const IngredientTabWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_rounded,
          size: 32.0.sp,
        ),
        onPressed: () async {
          await _addOtherCartItemDialog(context, user!);
        },
      ),
    );
  }

  Future<void> _addOtherCartItemDialog(
    BuildContext context,
    User user,
  ) {
    final buyListModel = BuyListModel(user: user);
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
                  final errorText = await buyListModel.addOtherCartItem(
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
