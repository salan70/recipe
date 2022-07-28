# myRecipe / レシピ記録アプリ

## 本アプリについて
FlutterとFirebaseで開発したモバイルアプリです。
現在は[iOS向けのアプリ](https://apps.apple.com/jp/app/myrecipe-%E3%83%AC%E3%82%B7%E3%83%94%E8%A8%98%E9%8C%B2%E3%82%A2%E3%83%97%E3%83%AA/id1627427244)のみリリースしています。

レシピを記録するとともに、記録したレシピから材料の買い物リストを作成することができます。

## 本アプリをリリースした背景
作りたいレシピに必要な材料を計算したりメモしたりする煩わしさから開放されたいという思いでこのアプリを作りました。


詳細は、Zennの[Flutterを学習してから個人開発アプリをリリースするまでの道のり](https://zenn.dev/maguroburger/articles/9ffaa882a45b4f)という記事をご覧いただけますと幸いです。

##  本アプリの機能
本アプリはFlutter, Firebase(Authentication, Firestore Database, Storage)を使い、次のような機能の実装を行いました。

- レシピの記録、読み取り、更新、削除
  <details><summary>画像</summary>

  | 記録 | 読み取り | 更新 | 削除 |
  | ---- | ---- | ---- | ---- |
  | <img src="https://user-images.githubusercontent.com/78355880/181409066-6ce8fc9d-8149-4026-89e9-28a620c11dc8.gif" width="200px">  | <img src="https://user-images.githubusercontent.com/78355880/181409103-553b6b42-156d-4ff8-bed3-1ebcd1dac4d0.gif" width="200px"> | <img src="https://user-images.githubusercontent.com/78355880/181409203-62f64205-b7aa-44a0-bd85-61cdceacb31c.gif" width="200px"> | <img src="https://user-images.githubusercontent.com/78355880/181409100-84b2410b-6996-4606-8dc7-6905f0b69729.gif" width="200px"> |
  </details>

- レシピの検索
  <details><summary>画像</summary>

  <img src="https://user-images.githubusercontent.com/78355880/181409175-535404cd-217e-4a38-a6ff-a7260e6748f3.gif" width="200px">
  </details>

- 記録したレシピをカートに追加し、カート内のレシピの材料から買い物リストを作成
  <details><summary>画像</summary>

  | カートへの追加 | 買い物リスト | 
  | ---- | ---- | 
  | <img src="https://user-images.githubusercontent.com/78355880/181409197-0b6016f8-8696-4f52-9eb4-bb5f89181edb.gif" width="200px"> | <img src="https://user-images.githubusercontent.com/78355880/181409099-9adc970e-5ea2-449a-a3e4-e86639423e33.gif" width="200px"> | 
  </details>

- 買い物リストにて、買うリストから買わないリストへの移動
  <details><summary>画像</summary>

  <img src="https://user-images.githubusercontent.com/78355880/181409096-64068288-f68f-44c0-b72c-e1bb1fbd2b7b.gif" width="200px">
  </details>

- ユーザー認証（匿名認証、メールアドレス認証、Googleアカウント認証、Appleアカウント認証）
  <details><summary>画像</summary>

  | 新規登録 | ログイン | 
  | ---- | ---- | 
  | <img src="https://user-images.githubusercontent.com/78355880/181409196-4fa0784e-3f74-4ae6-9200-8e2254a09cc0.PNG" width="200px"> | <img src="https://user-images.githubusercontent.com/78355880/181409101-0d5be2f6-af94-4319-8bfb-373d3d2b5d79.PNG" width="200px"> | 
  </details>

##  その他

- 状態管理には、Riverpodを用いています
- Firebaseの他に、ローカルにデータを保存するためにHiveを使っています
- Firestore、storageのSecurity Rulesとtestを実装しています
