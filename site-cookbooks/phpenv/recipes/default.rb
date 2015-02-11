#
# Cookbook Name:: phpenv
# Recipe:: default
#
# Copyright 2015, Katsuhiko Nagashima
#
# All rights reserved - Do Not Redistribute
#

# 配列で列挙しているパッケージをインストールする。
%w{curl mysql-client-5.5 php5 php5-cli php5-fpm php5-mysql php-pear php5-curl php5-xsl php5-mcrypt nginx git}.each do |p|
  package p do
    action :install
  end
end

# PHP mcrypt モジュールを有効にする。
execute "php5enmod mcrypt" do
  action :run
end

# Apache 利用しないので、パッケージがインストール済みの場合はサービスを停止し無効化する。
service "apache2" do
  action [:disable, :stop]
  only_if "dpkg -l | grep apache2"
end
# Apache サービス停止ではなく、アンインストールすることにする。
package "apache2" do
  action :remove
end

# Nginx テスト用設定ファイルをテンプレートから作成する。
template "/etc/nginx/sites-available/test" do
  source "test.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
  only_if { node['nginx']['test']['available'] == true }
end

# Nginx テスト用設定ファイルをシンボリックリンクを張ってする。
link "/etc/nginx/sites-enabled/test" do
  to "/etc/nginx/sites-available/test"
  only_if { node['nginx']['test']['available'] == true }
end

# Nginx デフォルトのサイト設定を上書きする。
template "/etc/nginx/sites-available/default" do
  source "default.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
end

# Nginx デフォルトドキュメントルートを作成する。
directory node['nginx']['docroot']['path'] do
  owner node['nginx']['docroot']['owner']
  group node['nginx']['docroot']['group']
  mode 0755
  action :create
  recursive true
  only_if { not File.exists?(node['nginx']['docroot']['path']) and node['nginx']['docroot']['force_create'] }
end

# Nginx ダミーの php スクリプトを作成する。
template "#{node['nginx']['docroot']['path']}/index.php" do
  source "index.php.erb"
  owner node['nginx']['docroot']['owner']
  group node['nginx']['docroot']['group']
  mode 0644
  action :create
  only_if { not File.exists?("#{node['nginx']['docroot']['path']}/index.php") and node['nginx']['docroot']['force_create'] }
end

#️ Nginx サービスを有効化して起動する。
service "nginx" do
  action [:enable, :restart]
end
