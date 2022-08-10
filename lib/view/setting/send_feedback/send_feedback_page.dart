import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../state/auth/auth_provider.dart';
import '../../../state/other_provider/providers.dart';
import 'send_feedback_model.dart';

class SendFeedbackPage extends ConsumerWidget {
  const SendFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);

    final feedback = ref.watch(feedbackProvider);
    final feedbackNotifier = ref.watch(feedbackProvider.notifier);

    final sendFeedbackModel = SendFeedbackModel(user: user!);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'ご意見・ご要望',
        ),
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.light
            ? CupertinoColors.extraLightBackgroundGray
            : Theme.of(context).backgroundColor,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16).r,
          child: ListView(
            children: [
              const Text(
                '「こういう機能が欲しい」「この機能はこういうふうにしてほしい」など、ご意見・ご要望がありましたら是非お聞かせください！'
                '\n\n※こちらからお送りいただいた内容への返信は行っておりません。'
                '返信が必要な場合は、前の画面に戻り「お問い合わせ」をお願いいたします。',
              ),
              SizedBox(
                height: 16.h,
              ),
              TextField(
                maxLines: 15,
                maxLength: 500,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).backgroundColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(8).r,
                ),
                onChanged: (text) {
                  feedbackNotifier.state = text;
                },
              ),
              Center(
                child: SizedBox(
                  width: 144.w,
                  child: ElevatedButton(
                    onPressed: () async {
                      await EasyLoading.show(status: 'loading...');

                      final errorText =
                          await sendFeedbackModel.sendFeedback(feedback);
                      if (errorText == null) {
                        Navigator.pop(context);
                        await EasyLoading.showSuccess('送信しました');
                      } else {
                        await EasyLoading.dismiss();
                        await showDialog<AlertDialog>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('送信失敗'),
                              content: Text(errorText),
                              actions: [
                                TextButton(
                                  child: const Text('閉じる'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      '送信',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
