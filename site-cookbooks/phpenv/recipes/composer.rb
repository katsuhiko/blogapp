#
# Cookbook Name:: phpenv
# Recipe:: composer
#
# Copyright 2015, Katsuhiko Nagashima
#
# All rights reserved - Do Not Redistribute
#

remote_file "/usr/local/bin/composer"  do
  source "http://getcomposer.org/composer.phar"
  action :create_if_missing
  owner "root"
  group "root"
  mode 0755
end
