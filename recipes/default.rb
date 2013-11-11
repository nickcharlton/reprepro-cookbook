#
# Cookbook Name:: reprepro
# Recipe:: default
#
# Copyright (c) 2013 Nick Charlton <nick@nickcharlton.net>
# 
# MIT Licensed.
#

include_recipe 'nginx'

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
# e.g.:
#   /var/packages/
#   /var/packages/{distro}/
#   /var/packages/{distro}/conf/   
node['reprepro']['distributions'].keys.each do |dist|
  directory "#{node['reprepro']['packages_path']}/#{dist}/conf" do
    owner 'packages'
    group 'packages'
    mode '0750'
    recursive true
  end
end

# import the GPG key

# populate the reprepro configuration
node['reprepro']['distributions'].keys.each do |dist|
  template "#{node['reprepro']['packages_path']}/#{dist}/conf/distributions" do
    source 'distributions.erb'
    owner 'packages'
    group 'packages'
    mode '0644'

    variables(
      :versions => node['reprepro']['distributions'][dist]
    )
  end

  template "#{node['reprepro']['packages_path']}/#{dist}/conf/options" do
    source 'options.erb'
    owner 'packages'
    group 'packages'
    mode '0644'
  end
end

# configure nginx to host it
template '/etc/nginx/sites-available/apt' do
  source 'apt.erb'
  mode '0644'
  variables(
    :repo_dir => node['reprepro']['packages_path']
  )
end

nginx_site 'apt'

