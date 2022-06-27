# myRecipe / レシピ記録アプリ

## 本アプリについて
FlutterとFirebaseで開発したモバイルアプリです。
現在は[iOS向けのアプリ](https://apps.apple.com/jp/app/myrecipe-%E3%83%AC%E3%82%B7%E3%83%94%E8%A8%98%E9%8C%B2%E3%82%A2%E3%83%97%E3%83%AA/id1627427244)のみリリースしています。

レシピを記録するとともに、記録したレシピから材料の買い物リストを作成することができます。

## 本アプリをリリースした背景
作りたいレシピに必要な材料を計算したりメモしたりする煩わしさから開放されたいという思いでこのアプリを作りました。

詳細は、Zennの[Flutterを学習してから個人開発アプリをリリースするまでの道のり](https://zenn.dev/maguroburger/articles/9ffaa882a45b4f)という記事に書きましたのでご覧いただけますと幸いです。

##  本アプリの機能
本アプリはFlutter, Firebase(Authentication, Firestore Database, Storage)を使い、次のような機能の実装を行いました。

- レシピの記録、更新、読み取り、削除
- レシピの検索
- 記録したレシピをカートに追加し、カート内のレシピの材料から買い物リストを作成
- 買い物リストから買わない物リストへの移動
- ユーザー認証（匿名認証、Googleアカウント認証、Appleアカウント認証）

##  その他

- 状態管理には、Riverpodを用いています
- Firebaseの他に、ローカルにデータを保存するためにHiveを使っています
- Firestore、storageのSecurity Rulesとtestを実装しています
