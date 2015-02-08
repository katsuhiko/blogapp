#
# Cookbook Name:: phpenv
# Recipe:: default
#
# Copyright 2015, Katsuhiko Nagashima
#
# All rights reserved - Do Not Redistribute
#

# 配列で列挙しているパッケージをインストールする。
%w{curl php5 php5-cli php5-fpm php5-mysql php-pear php5-curl php5-xsl php5-mcrypt nginx git}.each do |p|
	package p do
		action :install
  end
end

# mcrypt モジュールを有効にする。
execute "php5enmod mcrypt" do
  action :run
end

# 今回は Apache は利用しないので、パッケージがインストール済みの場合はサービスを停止し無効化する。
service "apache2" do
  action [:disable, :stop]
  only_if "dpkg -l | grep apache2"
end
# Apache はサービス停止ではなく、アンインストールすることにする。
package "apache2" do
  action :remove
end

# Nginx 用の設定ファイルをテンプレートから作成する。
template "/etc/nginx/sites-available/test" do
  source "test.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
  only_if { node['nginx']['test']['available'] == true }
end

# シンボリックリンクを張って設定ファイルを有効かする。
link "/etc/nginx/sites-enabled/test" do
  to "/etc/nginx/sites-available/test"
  only_if { node['nginx']['test']['available'] == true }
end

# デフォルトのサイト設定を上書きする。
template "/etc/nginx/sites-available/default" do
  source "default.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
end

# Nginx のドキュメントルートを作成する。
directory node['nginx']['docroot']['path'] do
  owner node['nginx']['docroot']['owner']
  group node['nginx']['docroot']['group']
  mode 0755
  action :create
  recursive true
  only_if { not File.exists?(node['nginx']['docroot']['path']) and node['nginx']['docroot']['force_create'] }
end

# ダミーの php スクリプトを作成する。
template "#{node['nginx']['docroot']['path']}/index.php" do
  source "index.php.erb"
  owner node['nginx']['docroot']['owner']
  group node['nginx']['docroot']['group']
  mode 0644
  action :create
  only_if { not File.exists?("#{node['nginx']['docroot']['path']}/index.php") and node['nginx']['docroot']['force_create'] }
end

#️ Nginx のサービスを有効化して起動する。
service "nginx" do
  action [:enable, :restart]
end
