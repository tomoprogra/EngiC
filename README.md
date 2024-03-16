# [EngiC.(エンジニアコネクター)]

## ■サービス概要
- エンジニアとして使える技術や、得意分野などをアピールできるデジタルプロフィールを簡単に作成できます。

###　アプリURL
https://engic.dev

###　開発者
https://twitter.com/anyonewww01

## ■ このサービスへの思い・作りたい理由
- プログラミングを学んでいる身として、オフ会などのイベントへの参加の際に相手を知れる手段に、気軽に交換できるプロフィールアプリがあれば会話も盛り上がり、交流が深まると思い、作成しました。


## ■ ユーザー層について
- 主にエンジニアで簡単にプロフィールを作りたい方
- 自分を知ってもらいたいと思うプログラミング初心者
- 開発者等で、業界内でのネットワークを広げたい方

## ■ サービスの差別化ポイント・推しポイント
- エンジニアに特化したポイントとしては、使える技術、得意分野、資格、SNSやGithubリンク、開発アプリリンクなどエンジニアとしてアピールポイントを記載できる。

## ■ 機能候補
### MVP
* 会員登録/ログイン(github,X)
* プロフィール作成編集機能（muuri.jsを使ってカードの順番変更機能）
  * github,X,note,qiita,zennプロフィールカード作成機能(リンク機能付き) 
  * URL、画像、コメントを記載できるカード作成機能
* Github Xアカウント紐付け機能
* スキルタグ作成機能
* スキルでユーザー検索機能
* ユーザー名で検索機能（オートコンプリート機能付き）
* QRコード作成表示機能
* SNS連携してプロフィールにSNSアカウント表示機能
* usernameからマイページURL編集機能
* 退会機能
* ページネーション機能
* Xシェア機能
* レスポンシブデザイン

## ■ 使用技術一覧

|カテゴリ|使用技術|
|:---:|:---:|
|フロントエンド|Tailwindcss,Hotwire,javascript|
|バックエンド|Ruby,Rails|
|コード解析/フォーマッター|Rubocop|
|テストフレームワーク|Rspec|
|データベース|postgresQL|
|認証|devise omniauth|
|環境構築|Docker,Docker-compose|
|CI/CD|Github Action|
|インフラ|render,S3（画像保存）|
|API|Github API, X API, NoteAPI|
|主要gem|imageMagick(画像編集webpに変換),rqrcode(QRコード生成)|
|主要gem|httparty,redcarpet,bullet|
|ライブラリ|muuri.js(カード順番変更)|

