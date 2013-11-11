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

Add the default cookbook to your run list, and after the next Chef run, you'll be
able to add packages to the repository like so:

```bash
sudo su packages
cd /var/packages/{distro}
reprepro includedeb {distro} {deb_file}
```

Using the default settings, the following can be added to `/etc/apt/sources.list`:

```
deb http://apt.example.com/debian/ wheezy non-free
```

The public key is published in the repository root, so this will import the key:

```
curl http://apt.example.com/pubkey.gpg | apt-key add -
```

Then, an `apt-get update` and `apt-get install {package_name}` will allow you to
install your self-hosted package.

## Attributes

* `reprepro['packages_path']`: where to place the packages. (default: `/var/packages`)
* `reprepro['distributions']`: a hash of distributions and versions to support. 
(default: `{'ubuntu' => ['precise'], 'debian' => ['wheezy']}`)
* `reprepro['fqdn']`: the domain name to configure the packages nginx configuration 
with. (default: `apt.example.com`)
* `reprepro['listen_port']`: the port to set the virtual host to list on (default: 80)
* `reprepro['description']`: the repository description field. (default:
`Custom APT repository`)

## Author

Author: Nick Charlton (<nick@nickcharlton.net>)

[reprepro]: http://packages.debian.org/search?keywords=reprepro
[nginx]: https://github.com/opscode-cookbooks/nginx

