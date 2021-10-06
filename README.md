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

割とモリモリ `/wuhu` の中身を書き換えることになるので、もしかしたらサブモジュールのwuhu自体もフォークしてバージョン管理したほうが良いかも

`http://localhost:8080` でビジター向けのページが見れます。

## その他

構成参考元: https://github.com/teeli/wuhu-docker (WUHU LICENSE)

MySQLでなくMariaDBです。
DBの中身を見るときは[HeidiSQL](https://www.heidisql.com/download.php)を使うと良さそう
