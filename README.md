# メモアプリ

このアプリケーションは、Sinatra を使ったメモ管理アプリです。メモの作成、表示、編集、削除ができます。

### 要件

---

Ruby 3.3.6 で動作確認しています。以下のコマンドでバージョンを確認してください。

```
$ ruby -v
```

Bundler：必要な Gem の管理に使用します。インストール方法は次の通りです。

```
$ gem install bundler
```

### インストール手順

---

以下の手順でプロジェクトをローカル環境にインストールしてください。

#### リポジトリのクローン

```
$ git clone https://github.com/kuma-900/memo_app.git
```

#### ディレクトリに移動

```
$ cd memo_app
```

#### Gem のインストール

以下のコマンドで必要な Gem をインストールします。Sinatra やコードチェック用の RuboCop、ERB Lint が含まれています。

```
$ bundle install
```

### ディレクトリ構造

---

```
memo_app/
├── data/
│   └── memos.json       # メモデータが保存されるJSONファイル
├── views/               # 各ページのビュー（HTMLテンプレート）
│   ├── edit.erb         # メモ編集ページのテンプレート
│   ├── index.erb        # メモ一覧ページのテンプレート
│   ├── new.erb          # メモ新規作成ページのテンプレート
│   └── show.erb         # メモ詳細ページのテンプレート
├── .erb_lint.yml        # ERB Lintの設定ファイル
├── app.rb               # アプリケーションのメインファイル
├── Gemfile              # 必要なGemを定義するファイル
├── Gemfile.lock         # Gemのバージョンを固定するファイル
└── README.md            # この説明書ファイル
```

### アプリケーションの起動

---

次のコマンドでアプリケーションを起動します。

```
$ bundle exec ruby app.rb
```

ブラウザで以下の URL にアクセスします。

http://localhost:4567

メモアプリの画面が表示されれば成功です。
