#
# Cookbook Name:: reprepro
# Recipe:: default
#
# Copyright (c) 2013 Nick Charlton <nick@nickcharlton.net>
# 
# MIT Licensed.
#

include_recipe 'chef-vault'
include_recipe 'nginx'

# extract further configuration from the vault
begin
  if Chef::Config[:solo]
    apt_repo = nil
  else
    apt_repo = chef_vault_item('reprepro', 'main')
  end
rescue ChefVault::Exceptions::KeysNotFound, OpenSSL::PKey::RSAError
  Chef::Log.warn('Could\'t find or decrypt the specified vault. The GPG components '\
    'will not be configured. This may not be what you want.')
end

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

# don't try and configure the gpg key unless we can access it
if apt_repo
  # import the private key
  # see: https://tickets.opscode.com/browse/CHEF-2288
  # there's also another problem with passing the key along a pipe writing it
  # to a file fixes this
  bash 'import packaging key' do
    code <<-EOH
    sudo -u packages HOME=/home/packages gpg --list-secret-keys --fingerprint \
'#{apt_repo['gpg']['email']}' | egrep -qx '.*Key fingerprint = \
#{apt_repo['gpg']['fingerprint']}'

    if [ $? -ne 1 ]; then 
      sudo -u packages /bin/echo -e "#{apt_repo['gpg']['public']}" > /home/packages/packages_pub.gpg
      sudo -u packages /bin/echo -e "#{apt_repo['gpg']['private']}" > /home/packages/packages_sec.gpg

      sudo -u packages HOME=/home/packages gpg --import /home/packages/packages_pub.gpg
      sudo -u packages HOME=/home/packages gpg --allow-secret-key-import --import /home/packages/packages_sec.gpg
    fi
    EOH
  end

  # place the public key …public
  template "#{node['reprepro']['packages_path']}/gpg_key.pub" do
    source 'gpg_key.erb'
    owner 'packages'
    group 'packages'
    mode '0644'

    variables(
      :key => apt_repo['gpg']['public']
    )
  end
end

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

