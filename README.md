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

    vagrant $ cd /var/www/application/app
    vagrant $ composer install

    vagrant $ mysql -uroot -ppassword
    mysql> GRANT ALL PRIVILEGES ON *.* TO 'webapp'@'%' identified by 'passw0rd' WITH GRANT OPTION;
    mysql> FLUSH PRIVILEGES;
    mysql> CREATE DATABASE blog default character set utf8;
    mysql> CREATE DATABASE test_blog default character set utf8;


## Vagrant URL

* Blogapp
  * http://192.168.33.10
* Jenkins
  * http://192.168.33.10:8080
