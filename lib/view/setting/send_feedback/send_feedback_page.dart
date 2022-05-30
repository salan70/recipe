import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/view/setting/send_feedback/send_feedback_model.dart';

class SendFeedbackPage extends ConsumerWidget {
  const SendFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);

    final feedback = ref.watch(feedbackProvider);
    final feedbackNotifier = ref.watch(feedbackProvider.notifier);

    SendFeedbackModel _sendFeedbackModel = SendFeedbackModel(user: user!);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'ご意見・ご要望',
        ),
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.light
            ? CupertinoColors.extraLightBackgroundGray
            : Theme.of(context).backgroundColor,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                  '「こういう機能が欲しい」「この機能はこういうふうにしてほしい」など、ご意見・ご要望がありましたら是非お聞かせください！\n\n※こちらからお送りいただいた内容への返信は行っておりません。返信が必要な場合は、前の画面に戻り「お問い合わせ」をお願いいたします。'),
              SizedBox(
                height: 16,
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
                  contentPadding: EdgeInsets.all(8),
                ),
                onChanged: (text) {
                  feedbackNotifier.state = text;
                },
              ),
              Center(
                child: SizedBox(
                  width: 144,
                  child: ElevatedButton(
                    onPressed: () async {
                      EasyLoading.show(status: 'loading...');

                      final errorText =
                          await _sendFeedbackModel.sendFeedback(feedback);
                      if (errorText == null) {
                        Navigator.pop(context);
                        EasyLoading.showSuccess('送信しました');
                      } else {
                        EasyLoading.dismiss();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('送信失敗'),
                              content: Text('$errorText'),
                              actions: [
                                TextButton(
                                  child: Text('閉じる'),
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
                      style: TextStyle(fontSize: 20),
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
