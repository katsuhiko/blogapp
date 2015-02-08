
$ git clone https://github.com/katsuhiko/blogapp.git blogapp
$ cd blogapp
$ berks vendor ./cookbooks
$ vagrant up

$ vagrant ssh

vagrant$ cd /var/www/application/app
vagrant$ composer install

Blogapp -> http://192.168.33.10
Jenkins -> http://192.168.33.10:8080
