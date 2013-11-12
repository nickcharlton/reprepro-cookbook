# reprepro cookbook

A better cookbook for configuring [reprepro][] to host an apt repository. This
doesn't include any apt caching support, and is configured to be hosted through
[nginx][]. The GPG key is stored in a [Vault][].

* https://wiki.debian.org/SettingUpSignedAptRepositoryWithReprepro
* http://joseph.ruscio.org/blog/2010/08/19/setting-up-an-apt-repository/

## Requirements

Tested on:

* Debian Wheezy (7.0)
* Ubuntu Precise (12.04)

## Usage

Add the default cookbook to your run list, and after the next Chef run (sort of, 
see the Chef Vault heading below), you'll be able to add packages to the repository 
like so:

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

## Chef Vault

[Chef Vault][Vault] allows you to encrypt secrets hosted on the Chef Server which
can only be decryped by listed parties. Typically, this is the administrators and
the nodes with a specific role applied. In this case, it means that the GPG key can
be made only accessible to the node which hosts the APT repository.

It assumes that the gpg key is held in a vault called `reprepro` with an item called
`main`. Which looks something like this:

```json
{
    "gpg": {
        "email": "",
        "fingerprint": "",
        "public": "",
        "private": ""
    }
}
```

Newlines in the GPG keys should be replaced with `\n` so that it's just one long 
line. You can do this with a quick bit of Ruby, for example:

```ruby
block = <<-BLOCK
-----BEGIN PGP PUBLIC KEY BLOCK-----
{snip}
-----END PGP PUBLIC KEY BLOCK-----
BLOCK

puts block.gsub('
', '\n')
```

Then you can encrypt the vault by doing:

```
knife encrypt create reprepro main -S "role:apt-repository" -A "nickcharlton" -M client -J vault/reprepro.json
```

## Author

Author: Nick Charlton (<nick@nickcharlton.net>)

[reprepro]: http://packages.debian.org/search?keywords=reprepro
[nginx]: https://github.com/opscode-cookbooks/nginx
[Vault]: https://github.com/Nordstrom/chef-vault

