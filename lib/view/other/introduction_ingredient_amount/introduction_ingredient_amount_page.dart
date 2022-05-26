import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IntroductionIngredientAmountPage extends ConsumerWidget {
  const IntroductionIngredientAmountPage({Key? key}) : super(key: key);

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
                  '材料の数量について、以下のような仕様となっております。',
                ),
                SizedBox(
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '入力できる種類や制限について',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '数量は、整数、少数、分数（帯分数含む）のいずれかで入力できます。\n帯分数で入力する際は「1 1/3」のように整数部分と小数部分の間に「スペース」を入力してください。'
                      '\n\nまた、入力できる文字数は5文字までとなっております。\n※「スペース」や「/（スラッシュ）」「.（コンマ）」はそれぞれ1文字としてカウントします。',
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'カートにレシピを入れた際の計算について',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '各材料は、材料名と単位がどちらも同じ場合に合算されます。\n合算時の計算は次のような優先順位で行われます。\n\n少数 > 分数 > 整数'
                      '\n例)\n「ねぎ 0.5本」と人参「ねぎ 1/4本」の場合、「ねぎ 0.75本」\n「ねぎ 1本」と「ねぎ 1/2本」の場合、「ねぎ 1 1/2本」',
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'その他',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '数量は未入力（空欄）も可能となっております。'
                      '\n「適量」や「少々」など、具体的な数量がない数量の場合は、「適量」や「少々」などを単位で設定するのがおすすめです。',
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
