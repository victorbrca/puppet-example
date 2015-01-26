Install Ubuntu Node
==================

These instructions are for Puppet Enterprise. Puppet Open Source does not include `pe_repo`.


#### Enable Ubuntu puppet repo on master

1- Edit /etc/puppetlabs/puppet/manifests/site.pp

```puppet
node "puppetmaster.mydomain.com" {
        include pe_repo::platform::ubuntu_1404_amd64
}
```

2- Run puppet agent

```puppet
puppet agent -t
```

#### Enable SSH and Download Puppet Agent on Node

1- Enable root SSH login

```bash
PermitRootLogin yes
```

2- Restart SSH

```bash
service ssh restart
```

3- Download Puppet Agent

```bash
curl -k https://puppetmaster.mydomain.com:8140/packages/current/install.bash | bash
```

or

```bash
wget --no-check-certificate https://puppetmaster.mydomain.com:8140/packages/current/install.bash

bash install.bash
```

#### Sign Cert on Master and Run Agent on Node

Find node cert

```bash
puppet cert list
  "ubuntunode.mydomain.com" (SHA256) 7D:A3:C5:2F:5E:95:78:7C:95:5F:E9:A6:56:7A:87:AA:FA:28:FF:13:25:A5:59:DE:E1:76:76:16:6C:7D:C6:8B
```

Sign agent on master

```bash
puppet cert sign ubuntunode.mydomain.com
```

Run `puppet agent` on node again, or wait for next run time (dictated by option `runinterval` on agent)

```bash
puppet agent -t
```

