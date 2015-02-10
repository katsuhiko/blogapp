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
    vagrant $ Console/cate test app AllTests


## Vagrant URL

* Blogapp
  * http://192.168.33.10
* Jenkins
  * http://192.168.33.10:8080


## Console

    cd /var/www/application/current/app

    // Composer で導入
    vagrant $ composer require "cakedc/migration:~2.3"
    // Composer で導入(開発用)
    vagrant $ composer require --dev "sizuhiko/fabricate:1.*"
    // Composer ライブラリインストール(lock ファイルのバージョンに従う)
    vagrant $ composer install
    // Composer ライブラリバージョンの更新 / インストール(lock ファイルを更新する)
    vagrant $ composer update

    // Migration マイグレーションファイルの作成
    vagrant $ Console/cake migrations.migration generate create_posts id:primary_key title:string body:text created modified
    // Migration 実行するSQLの確認(dry run モード)
    vagrant $ Console/cake migrations.migration run all -d
    // Migration マイグレーションの実施
    vagrant $ Console/cake migrations.migration run all

    // PHPUnit 全テストの実行
    vagrant $ Console/cake test app AllTests
    // PHPUnit テストファイルを指定して実行
    vagrant $ Console/cake test app Config/Routes

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


## Troubleshooting

### vagrant provision でエラー

    Shared folders that Chef requires are missing on the virtual machine.
    This is usually due to configuration changing after already booting the
    machine. The fix is to run a `vagrant reload` so that the proper shared
    folders will be prepared and mounted on the VM.

以下を実施すると回避できる。

    host $ rm .vagrant/machines/default/virtualbox/synced_folders
    host $ vagrant reload --provision
