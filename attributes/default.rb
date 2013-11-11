#
# Cookbook Name:: reprepro
# Attributes:: default
#
# Copyright (c) 2013 Nick Charlton <nick@nickcharlton.net>
# 
# MIT Licensed.
#

default['reprepro']['packages_path'] = '/var/packages'
default['reprepro']['distributions'] = {'ubuntu' => ['precise'], 
                                        'debian' => ['wheezy']}

default['reprepro']['fqdn'] = 'apt.example.com'
default['reprepro']['listen_port'] = 80
default['reprepro']['description'] = 'Custom APT Repository'


