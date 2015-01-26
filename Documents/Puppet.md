Puppet
=======

Puppet is idempotent (the Puppet catalog can safely be applied multiple times)



Puppet Enterprise
-----------------

- License should be placed in `/etc/puppetlabs/license.key`
- Puppet Enterprise comes with a 10 node license for free. Beyond that a commercial per-node license is needed

The following components are installed by default:
- PUppet
- PuppetDB
- Facter
- MCollective
- Hiera
- Puppet Dashboard

Log file locations:

```
$ ls -1d /var/log/pe*
/var/log/pe-activemq
/var/log/pe-console-auth
/var/log/pe-httpd
/var/log/pe-installer
/var/log/pe-mcollective
/var/log/pe-postgresql
/var/log/pe-puppet
/var/log/pe-puppet-dashboard
/var/log/pe-puppetdb
```


Puppet Open Source
-----------------