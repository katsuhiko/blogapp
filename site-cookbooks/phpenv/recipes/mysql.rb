#
# Cookbook Name:: phpenv
# Recipe:: mysql
#
# Copyright 2015, Katsuhiko Nagashima
#
# All rights reserved - Do Not Redistribute
#

# 配列で列挙しているパッケージをインストールする。
%w{mysql-server-5.5}.each do |p|
  package p do
    action :install
  end
end

# MySQL のサービスを有効化して起動する。
service "mysql" do
  action [:enable, :restart]
  supports :status => true, :start => true, :stop => true, :restart => true
  not_if do File.exists?("/var/run/mysqld/mysqld.pid") end
end

# MySQL の root アカウントのパスワードをセットする。
execute "set_mysql_root_password" do
  command "/usr/bin/mysqladmin -u root password \"#{node['mysql']['root_password']}\""
  action :run
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end
