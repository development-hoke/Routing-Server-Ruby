# one-date-server

1Date のサーバーサイドのリポジトリです。

*フロントエンドはこちら [one-date-client](https://github.com/1date-inc/one-date-client)*

## Technology

* Ruby `2.5.3`
* Ruby on Rails `5.2.2`
* MySQL `5.7`
* Docker / Docker Compose

## Getting Started

* 事前準備

[Docker Desktop for Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac) 等をインストールして docker, docker-compose を実行できる環境を用意する。

* ソースコードのクローン

```bash
$ git clone git@github.com:1date-inc/one-date-server.git
$ cd one-date-server
```

* イメージの作成・サービスの起動

```bash
# 初回
$ docker-compose up -d --build

# 2回目以降
$ docker-compose up -d
```

* アプリケーション起動

*（初回はDBのセットアップも自動で行われます）*

```bash
$ ./start-server.sh
```

→ http://localhost:3080 でアプリケーションにアクセスできます。

* サービスの停止

```bash
$ docker-compose down
```

## API Spec

API仕様書は OpenAPI + ReDoc で管理します。  
`openapi.yml` を編集してください。

```bash
# OpenAPIからReDocへの書き出し
$ ./redoc.sh
```

→ アプリケーションを起動中 http://localhost:3080/redoc.html で確認できます。

## Database Information

データベース名 `onedate_db`

| テーブル物理名 | 論理名 |
|:---|:---|
| `users` | ユーザー |
| `plans` | デートプラン |
| `spots` | デートスポット |
| `images` | デートスポット画像 |
| `routes` | デートプランに含まれるスポット(ルート情報) |
| `likes` | デートプランへのいいね |
| `favorites` | デートプランのお気に入り |
| `comments` | デートプランへのコメント |
| `follows` | アカウントのフォロー関係 |
| `histories` | デートプラン検索履歴 |
| `notifications` | 通知 |
| `questions` | 問い合わせ |
| `settings` | ユーザーカスタム設定 |
| `staff` | 運営スタッフ |

## Utility Commands

開発中よく使うコマンドたち

```bash
# DBを覘く
$ docker-compose exec mysql bash -c "mysql -u root -p"

# Gemfile更新時にパッケージ更新
$ docker-compose exec app sh -c "bundle install"

# マイグレーションファイルの作成
$ docker-compose exec app sh -c "bundle exec rails g migration ClassName"

# マイグレーション実行
$ docker-compose exec app sh -c "bundle exec rails db:migrate"

# サンプルデータ投入
$ docker-compose exec app sh -c "bundle exec rails db:seed"

# DBリセット
$ docker-compose exec app sh -c "bundle exec rails db:reset"

# Rails コンソールに入る
$ docker-compose exec app sh -c "bundle exec rails console"
```
