import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchRecipePage extends ConsumerWidget {
  const SearchRecipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'レシピ名、材料名で検索',
                  suffixIconConstraints:
                      BoxConstraints(maxHeight: 24.h, maxWidth: 24.w),
                ),
                onSubmitted: (searchWord) {
                  //TODO searchWordを次の画面に渡して検索を行う
                },
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 24.w,
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).backgroundColor,
      ),
    );
  }
}
