import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IntroductionTakeOverPage extends ConsumerWidget {
  const IntroductionTakeOverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('説明'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ログインによって引き継がれる/引き継がれない要素は以下のとおりです。',
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  '引き継がれる要素',
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
                // 引き継がれる要素
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '・登録しているレシピの情報（名前、画像、材料、メモ etc...）',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '・カートに入っているレシピの数',
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  '引き継がれない要素',
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                  textAlign: TextAlign.left,
                ),
                // 引き継がれない要素
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '・カートの材料のチェック状況\n※全てのチェックが外されます。',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '・カートの材料の「買わないリスト」への移動\n※全ての材料が「買うリスト」に入っている状態になります。',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '・カスタマイズした材料の単位\n※追加、削除、順番入れ替え、全てが初期化されます。',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '・カスタマイズしたテーマモード\n※「デバイスに合わせる」になります。',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
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
