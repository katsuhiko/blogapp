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

    // マイグレーションファイルの作成
    vagrant $ Console/cake migrations.migration generate create_posts id:primary_key title:string body:text created modified
    // 実行するSQLの確認(dry run モード)
    vagrant $ Console/cake migrations.migration run all -d
    // マイグレーションの実施
    vagrant $ Console/cake migrations.migration run all

    // テストの実行(個別)
    vagrant $ Console/cake test app Config/Routes
    // テストの実行(すべて)
    vagrant $ Console/cake test app AllTests

    // Bake モデルの雛形を作成
    vagrant $ Console/cake bake model Post
    // Bake コントローラーの雛形を作成
    vagrant $ Console/cake bake controller Post
    // Bake フィクスチャの雛形を作成
    vagrant $ Console/cake bake fixture -s -n 1


## Troubleshooting

### vagrant provision でエラー

    Shared folders that Chef requires are missing on the virtual machine.
    This is usually due to configuration changing after already booting the
    machine. The fix is to run a `vagrant reload` so that the proper shared
    folders will be prepared and mounted on the VM.

以下を実施すると回避できる。

    host $ rm .vagrant/machines/default/virtualbox/synced_folders
    host $ vagrant reload --provision
