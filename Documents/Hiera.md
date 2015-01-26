Hiera
=====
[Hiera](https://docs.puppetlabs.com/hiera/1/index.html)
[Installing and Using Hiera](http://puppetlabs.com/blog/first-look-installing-and-using-hiera)

Hiera is a key/value lookup tool for configuration data that lets you set node-specific data without repeating yourself.

It is installed by default on Puppet Enterprise 3 and up.

It provides a command line tool for testing `key:value` lookups

#### Configuration files

- Puppet Enterprise: /etc/puppetlabs/puppet/hiera.yaml
- Puppet OpenSource:/etc/puppet/hiera.yaml

**Example config file**
```yaml
---
:backends:
  - yaml
:hierarchy:
  - defaults
  - "node/%{clientcert}"
  - "%{environment}"
  - "%{::osfamily}"
  - global

:yaml:
# datadir is empty here, so hiera uses its defaults:
# - /var/lib/hiera on *nix
# - %CommonAppData%\PuppetLabs\hiera\var on Windows
# When specifying a datadir, make sure the directory exists.
  :datadir: /etc/puppetlabs/puppet/hieradata
```

*[1] You could also use puppet's environment variable to specify different datadir (files) for each environment (`:datadir: '/etc/puppetlabs/puppet/environments/%{environment}/hieradata'`)*

**Example data directory**

```
# /etc/puppetlabs/puppet/hieradata/
.
├── dev.yaml
├── debian.yaml
├── global.yaml
├── node
│   └── host.mydomain.com.yaml
└── redhat.yaml
```

**Example data files**

```yaml
# dev.yaml
---
url: dev.mydomain.com

# debian.yaml
---
url: debian.mydomain.com

# redhat.yaml (this is a hash)
---
users:
  jeff:
    home: /home/jeff
    shell: /bin/bash
  joe:
    home: /home/joe
    shell: /bin/bash
    
# global.yaml (this is a list)
ntp::servers:
  - kermit.example.com iburst
  - 0.us.pool.ntp.org iburst
  - 1.us.pool.ntp.org iburst
  - 2.us.pool.ntp.org iburst
```

**Example Data Types**

```yaml
---
# array
apache-packages:
    - apache2
    - apache2-common
    - apache2-utils

# string
apache-service: apache2

# interpolated facter variable
hosts_entry: "sandbox.%{fqdn}"

# hash
sshd_settings:
    root_allowed: "no"
    password_allowed: "yes"

# alternate hash notation
sshd_settings: {root_allowed: "no", password_allowed: "yes"}

# to return "true" or "false"
sshd_settings: {root_allowed: no, password_allowed: yes}
```

### Hiera and class parameters

```puppet
class hierademo ($parameter = "default") {
    ...
}
```

The code above will:

1. Look in the class declaration to see if a parameter is passed (like `class { "parameter => 'value': }`. If no value is passed it will
2. Look in the hiera data source for `hierademo::parameter`. If that doesn't exist it will 
3. Use the define value `'default'`

### Lookup Functions

- hiera: Finds the first matching value from the top of the data source and returns only that value
- hiera_array: Finds all possible matches and return all values in hierarchy order
- hiera_hash: Finds all possible matches, gets hashes for each match and returns all hashes in one single hash
