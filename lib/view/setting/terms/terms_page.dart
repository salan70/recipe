import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:recipe/state/other_provider/providers.dart';

/// (after release) TODO 起動時、デバイスがdarkで、アプリがlightの場合、一瞬黒い画面が表示されるの修正
class TermsPage extends ConsumerWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    final isLoadingNotifier = ref.watch(isLoadingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('利用規約'),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              isLoading == true ? LinearProgressIndicator() : Container(),
              Expanded(
                child: WebView(
                  initialUrl: 'https://salan70.github.io/recipe/terms',
                  onPageStarted: (value) {
                    isLoadingNotifier.state = true;
                  },
                  onPageFinished: (value) {
                    isLoadingNotifier.state = false;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
