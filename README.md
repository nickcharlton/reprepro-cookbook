# reprepro cookbook

A better cookbook for configuring [reprepro][] to host an apt repository. This
doesn't include any apt caching support, and is configured to be hosted through
[nginx][].

* https://wiki.debian.org/SettingUpSignedAptRepositoryWithReprepro
* http://joseph.ruscio.org/blog/2010/08/19/setting-up-an-apt-repository/

## Requirements

Tested on:

* Debian Wheezy (7.0)
* Ubuntu Precise (12.04)

## Usage

## Attributes

* `reprepro['packages_path']`: where to place the packages. (default: `/var/packages`)
* `reprepro['distributions']`: a hash of distributions and versions to support. 
(default: `{'ubuntu' => ['precise'], 'debian' => ['wheezy']}`)
* `reprepro['fqdn']`: the domain name to configure the packages nginx configuration 
with. (default: `apt.example.com`)
* `reprepro['description']`: the repository description field. (default: `Custom APT
repository`)

## Recipes

## Author

Author: Nick Charlton (<nick@nickcharlton.net>)

[reprepro]: http://packages.debian.org/search?keywords=reprepro
[nginx]: https://github.com/opscode-cookbooks/nginx

