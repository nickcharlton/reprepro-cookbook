#
# Cookbook Name:: reprepro
# Recipe:: default
#
# Copyright (c) 2013 Nick Charlton <nick@nickcharlton.net>
# 
# MIT Licensed.
#

# install the reprepro dependencies
%w{apt-utils dpkg-dev reprepro debian-keyring devscripts dput}.each do |pkg|
  package pkg
end

# create a user to hold the packages and key
user 'packages' do
  home '/home/packages'
  shell '/bin/bash'
  comment 'User for Managing the APT repository'
  system true
  supports :manage_home => true
  action :create
end

# build the reprepro directory structure

# import the GPG key

# populate the reprepro configuration

# configure nginx to host it

