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

  | 記録 | 読み取り | 更新 |
  | ---- | ---- | ---- |
  | ![intro_create_recipe](https://user-images.githubusercontent.com/78355880/175882068-38729504-ea77-4093-b1e8-ea6f27d81eba.gif) | ![intro_read_recipe](https://user-images.githubusercontent.com/78355880/175882101-d6b09631-2aa1-4d36-b61f-30b494fb49ad.png) | ![intro_update_recipe](https://user-images.githubusercontent.com/78355880/175882105-bc74276a-03d8-4c88-972f-13bd12507b88.gif) |
  </details>

- レシピの検索
  <details><summary>画像</summary>

  ![intro_search_recipe](https://user-images.githubusercontent.com/78355880/175886607-9cd95268-91f9-40ff-8eab-cfd4169c5bfb.gif)
  </details>

- 記録したレシピをカートに追加し、カート内のレシピの材料から買い物リストを作成
  <details><summary>画像</summary>

  | カートへの追加 | 買い物リスト | 
  | ---- | ---- | 
  | ![intro_add_cart_recipe](https://user-images.githubusercontent.com/78355880/175889498-ac4d426b-f25d-4ae3-bb9d-5ff0fca5bcc4.gif) | ![intro_buy_list](https://user-images.githubusercontent.com/78355880/175888532-b6136004-3ef2-4941-830c-4dd0ad592abf.PNG) | 
  </details>

- 買い物リストにて、買うリストから買わないリストへの移動
  <details><summary>画像</summary>

  ![intro_move_list](https://user-images.githubusercontent.com/78355880/175890370-91b7ea29-b2ce-4335-b982-0c18f9208879.gif)
  </details>

- ユーザー認証（匿名認証、メールアドレス認証、Googleアカウント認証、Appleアカウント認証）
  <details><summary>画像</summary>

  | 新規登録 | ログイン | 
  | ---- | ---- | 
  | ![intro_signupPNG](https://user-images.githubusercontent.com/78355880/175891084-9448a8bf-4622-439e-9371-091d20493a30.PNG) | ![intro_login](https://user-images.githubusercontent.com/78355880/175891068-3a4694da-8b0d-4021-85b6-25e144cb9f69.PNG) | 
  </details>

##  その他

- 状態管理には、Riverpodを用いています
- Firebaseの他に、ローカルにデータを保存するためにHiveを使っています
- Firestore、storageのSecurity Rulesとtestを実装しています
