# wuhu-docker

## Setup

### 前提

- [Docker Desktop](https://docs.docker.com/get-docker/)のインストール

### Cloneする

```sh
git clone --recursive https://github.com/0b5vr/wuhu-docker.git
cd wuhu-docker
```

wuhu自体をsubmoduleとして持つので、 `--recursive` を忘れず！
忘れた場合は `git submodule update --init --recursive` でリカバリ

### 立ち上げる

```sh
docker-compose build
docker-compose up
```

### 初期セットアップ

`http://localhost:8081` に行き、 `http://localhost:8081/config.php` にリダイレクトされたらいい感じ

フォームが表示されるので、入力していきます。上から順に:

- パーティ名。～～などでユーザに表示されます: お好きに
- user-side interfaceのパス: `/var/www/www_party` （初期値通り）
- コンポエントリーを保持するパス: `/var/www/entries_private` （初期値通り）
- コンポエントリーを吐き出すパス: `/var/www/entries_public`
- コンポエントリーのスクショを保持するパス: `/var/www/screenshots` （初期値通り）
- スクショのサイズ: 多分160x90のままで大丈夫
- 投票形式: Range votingのほうがよくある5段階評価。Shader Showdownなどで使われるLive votingにはこれが必要らしい
- パーティ開始日: ～～などで使われます
- MySQLのDB名: wuhu
- mySQLのユーザ名: wuhu
- MySQLのパスワード: wuhu
- Party Adminのユーザ名: お好きに
- Party Adminのパスワード: お好きに

ここで、 `.htaccess` が生成されるのですが、
`AuthGroupFile /dev/null` という行があると動かないので、手動で消してください。

"Invalid command 'AuthGroupfile', perhaps misspelled" とかでググると何が起こっているかはわかるはず。

### その後

基本的にはMain PageのTO-DO Listに従って進行すれば良いです。

Pluginsの "Live Voting" は有効化しないとShader Showdownが始められない。  
ほかにもいろいろ面白そうなPluginsがありますよ。  
TDFが終わったらどのプラグインを使ったら良さそうかまとめようね

Live Votingはコンポの作品投稿・更新を締め切らないと開始できない。  
各作品のチェックを手動で入れていくオペレーションが必要。一人でやってたら絶対忘れるやつ。

割とモリモリ `/wuhu` の中身を書き換えることになるので、もしかしたらサブモジュールのwuhu自体もフォークしてバージョン管理したほうが良いかも

`http://localhost:8080` でビジター向けのページが見れます。

デフォルトだとコンポのサイズ制限が128MBですが、`php.ini` の `upload_max_filesize` から変更できます。

## スライドショー

定常時のスライドショーは SLIDE EDITOR というのからやります。  
text slideはHTMLを入れられると書いてあるが、  
また、画像（GIF含む）・動画が使えそうです。動画は音も鳴ります  
スライドショーをするには、SLIDEVIEWERで `S` キーを押す  
スライド長さの調整は不可  
SLIDEVIEWERのURLクエリに `prizegivingStyle`

## コンポのファイル

### オーガナイザー向け

`entries_private/` 下には、並び替えた順番で連番の振ってあるエントリーのフォルダ群があるので、これをそのまま作業用のディレクトリとして使ってしまえばOK
`entries_private/` にアクセスできない場合は、adminのコンポのエントリーリストからファイル名をクリックでダウンロードができる
今、コンポのフォルダをまとめてダウンロードできる機能のPRを投げてます → https://github.com/Gargaj/wuhu/pull/69

### 参加者向け

adminのコンポのエントリーリストから `Export compo stuff to export directory` を使うと、エントリーが `entries_public/` に移動します。
`entries_public/` をHTTPSかなんかでサーブできるようにしておこう

## スライド背景にWebGLを使う

ほぼほぼ `wuhu\www_admin\slideviewer\index_webgl_example.html` の通り。

Prototype.jsという古代から伝わる様式でクラスが定義されている。
`WuhuSlideSystemCanvas` というクラスをPrototype.jsの書式で継承し、
`initialize` ・ `animate` という名通りの2メソッドを `$super` を叩きながら定義すればオッケー。

例えば、Canvasを渡すとレンダリングを行うだけのモジュールを用いた場合、以下のようなコードになる:

```js
// MyCanvasModuleというモジュールがあると仮定

var MyWuhuSlideSystemCanvas = Class.create(WuhuSlideSystemCanvas, {
  initialize: function($super, options) {
    $super(options);
    this.myCanvasModule = new MyCanvasModule(this.sourceCanvas);
  },
  animate: function($super) {
    this.myCanvasModule?.update(); // `this.myCanvasModule` は `undefined` になりうる
    $super();
  },
});

// あとは `MyWuhuSlideSystemCanvas` を `WuhuSlideSystem` の代わりに使うだけ
```

## リセット

以下のファイルをぶっ飛ばせばとりあえず初期状態に戻ります

- `database/`: ここ以下がDBです。 `docker-compose.yml` 内でボリュームマウントしてます
- `entries_private/`: adminが見えるエントリーのリスト
- `entries_public/`: 参加者が見えるエントリーのリスト
- `screenshots/`: コンポ作品のスクリーンショット
- `wuhu/www_admin/.htaccess`
- `wuhu/www_admin/.htpasswd`
- `wuhu/www_admin/database.inc.php`

## その他

構成参考元: https://github.com/teeli/wuhu-docker (WUHU LICENSE)

MySQLでなくMariaDBです。
DBの中身を見るときは[HeidiSQL](https://www.heidisql.com/download.php)を使うと良さそう
