# 「CakePHPで学ぶ継続的インテグレーション」写経

## Requirements

* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](http://vagrantup.com)
* [ChefDK](https://downloads.chef.io/chef-dk/)

### Vagrant Plugins installation

    host $ vagrant plugin install vagrant-omnibus
    host $ vagrant plugin install vagrant-cachier

### Chef additional installation

    host $ chef gem install knife-solo


## How To Build

    host $ git clone https://github.com/katsuhiko/blogapp.git blogapp
    host $ cd blogapp
    host $ berks vendor ./cookbooks
    host $ vagrant up

    host $ vagrant ssh

    vagrant $ mysql -uroot -ppassword
    mysql> GRANT ALL PRIVILEGES ON *.* TO 'webapp'@'%' identified by 'passw0rd' WITH GRANT OPTION;
    mysql> FLUSH PRIVILEGES;
    mysql> CREATE DATABASE blog default character set utf8;
    mysql> CREATE DATABASE test_blog default character set utf8;

    vagrant $ cd /var/www/application/current/app
    vagrant $ composer install
    vagrant $ Console/cake migrations.migration run all
    vagrant $ Console/cake test app AllTests
    vagrant $ Console/cake Bdd.story


## Vagrant URL

* Blogapp
  * http://192.168.33.10


## Console

    // Vagrant
    host $ cd blogapp
    // Vagrant 起動
    host $ vagrant up
    // Vagrant 停止
    host $ vagrant halt
    // Vagrant プロビジョン(仮想環境更新)
    host $ vagrant provision
    // Vagrant 仮想環境破棄
    host $ vagrant destroy

    // Chef
    host $ cd blogapp
    // Chef cookbooks更新
    host $ rm -rf cookbooks
    host $ berks vendor ./cookbooks

    // Composer
    vagrant $ cd /var/www/application/current/app
    // Composer で導入
    vagrant $ composer require "cakedc/migration:~2.3"
    // Composer で導入(開発用)
    vagrant $ composer require --dev "sizuhiko/fabricate:1.*"
    // Composer ライブラリインストール(lock ファイルのバージョンに従う)
    vagrant $ composer install
    // Composer ライブラリバージョンの更新 / インストール(lock ファイルを更新する)
    vagrant $ composer update

    // Migration
    vagrant $ cd /var/www/application/current/app
    // Migration マイグレーションファイルの作成
    vagrant $ Console/cake migrations.migration generate create_posts id:primary_key title:string body:text created modified
    // Migration 実行するSQLの確認(dry run モード)
    vagrant $ Console/cake migrations.migration run all -d
    // Migration マイグレーションの実施
    vagrant $ Console/cake migrations.migration run all

    // UnitTest
    vagrant $ cd /var/www/application/current/app
    // UnitTest 全テストの実行
    vagrant $ Console/cake test app AllTests
    // UnitTest テストファイルを指定して実行
    vagrant $ Console/cake test app Config/Routes

    // Bake
    vagrant $ cd /var/www/application/current/app
    // Bake モデルの雛形を作成
    vagrant $ Console/cake bake model Post
    // Bake コントローラーの雛形を作成
    vagrant $ Console/cake bake controller Post
    // Bake フィクスチャの雛形を作成
    vagrant $ Console/cake bake fixture -s -n 1

    // BDD
    vagrant $ cd /var/www/application/current
    // BDD 利用可能なステップの確認
    vagrant $ app/Console/cake Bbb.story -dl --lang=ja
    // BDD 全フィーチャーの実行
    vagrant $ app/Console/cake Bdd.story
    // BDD フィーチャーファイルを指定して実行
    vagrant $ app/Console/cake Bdd.story features/blog_posts.feature

    // Phing
    vagrant $ cd /var/www/application/current
    // Phing ビルドの実行
    vagrant $ app/Vendor/bin/phing


## Troubleshooting

### vagrant provision でエラー

    Shared folders that Chef requires are missing on the virtual machine.
    This is usually due to configuration changing after already booting the
    machine. The fix is to run a `vagrant reload` so that the proper shared
    folders will be prepared and mounted on the VM.

以下を実施すると回避できる。

    host $ rm .vagrant/machines/default/virtualbox/synced_folders
    host $ vagrant reload --provision


## Create CI Server on EC2

Amazon Linux で動かしたかったけど、写経した Recipe が Ubuntu に特化しすぎてて、対応するのが大変。

EC2 に Ubuntu(Ubuntu Server 14.04 LTS (HVM), SSD Volume Type - ami-20b6aa21) を利用することに変更。

Amazon Linux で動作するようにしたい。
ディレクトリ構成や初期設定ファイル状態がかなり違うので、
Nginx / php-fpm の設定を見直す必要がある。

### 参考にしたサイト

* [Amazon Linuxにknife-soloの実行環境を構築してみる](http://dev.classmethod.jp/cloud/amazon-linux_knife-solo/)
* [About the Recipe DSL - OSによる切替についての記載がある](https://docs.chef.io/dsl_recipe.html)
* [Export/import jobs in Jenkins](http://stackoverflow.com/questions/8424228/export-import-jobs-in-jenkins)

### EC2 CIサーバーインスタンス作成メモ

* AMI Ubuntu Server 14.04 LTS (HVM), SSD Volume Type - ami-20b6aa21
* ScrityGroup SSH:22、Jenkins用:8080 ポートへの inbounds rule を追加

### knife solo による CIサーバー環境設定

    // CIサーバーに接続できることを確認する。
    host $ ssh -i ~/.ssh/xxx.pem xxx@255.255.255.255

    host $ cd blogapp
    host $ rm -rf cookbooks
    host $ berks vendor ./cookbooks
    host $ knife solo prepare xxx@255.255.255.255 -i ~/.ssh/xxx.pem 
    host $ knife solo cook --node-name ec2_ci xxx@255.255.255.255 -i ~/.ssh/xxx.pem

### DB の作成

    vagrant $ mysql -uxxx -pxxx -h xxx
    mysql> CREATE DATABASE blog default character set utf8;
    mysql> CREATE DATABASE test_blog default character set utf8;

### Jenkins の設定

    host $ cd blogapp
    host $ scp -i ~/.ssh/xxx.pem ./jenkins-config.xml xxx@255.255.255.255:~/

    host $ ssh -i ~/.ssh/xxx.pem xxx@255.255.255.255
    ec2 $ sudo /usr/bin/java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 create-job blogapp < ./jenkins-config.xml

Jnkins サイトにて、プロジェクト「blogapp」を選択して、左メニュー「設定」、
シェルの実行欄の１行目にDB接続の環境変数を設定する。

    export MYSQL_DB_HOST=xxx

### Nginx 接続先DBの環境変数設定

    ec2 $ sudo vi /etc/nginx/sites-available/test
    
    20行目付近の CAKE_ENV の下にDB接続先の環境変数をセットする。
    fastcgi_param MYSQL_DB_HOST xxx
    
    ec2 $ sudo service nginx restart
