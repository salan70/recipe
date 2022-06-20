import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroductionTakeOverPage extends ConsumerWidget {
  const IntroductionTakeOverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('説明'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16).r,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ログインによって引き継がれる/引き継がれない要素は以下のとおりです。',
                ),
                SizedBox(
                  height: 24.h,
                ),
                // 引き継がれる要素
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '引き継がれる要素',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    const Text(
                      '・登録しているレシピの情報（名前、画像、材料、メモ etc...）',
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    const Text(
                      '・カートに入っているレシピの数',
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.h,
                ),
                // 引き継がれない要素
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '引き継がれない要素',
                      style: Theme.of(context).textTheme.subtitle2,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    const Text(
                      '・カートの材料のチェック状況\n※全てのチェックが外されます。',
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    const Text(
                      '・カートの材料の「買わないリスト」への移動\n※全ての材料が「買うリスト」に入っている状態になります。',
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    const Text(
                      '・カスタマイズした材料の単位\n※追加、削除、順番入れ替え、全てが初期化されます。',
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    const Text(
                      '・カスタマイズしたテーマモード\n※「デバイスに合わせる」になります。',
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    const Text(
                      '・カスタマイズしたテーマカラー\n※「green」になります。',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
