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

# build the reprepro directory structure

# import the GPG key

# populate the reprepro configuration

# configure nginx to host it

