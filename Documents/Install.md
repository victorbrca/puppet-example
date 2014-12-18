# Install steps

## Puppet Enterprise

### Master

Enable root login

```bash
PermitRootLogin yes
service sshd restart
```

Setup FQDN on Puppet master

```bash
cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
127.0.1.1   victorbrca1.mylabserver.com
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```

Download puppet-enterprise from puppet labs (http://puppetlabs.com/download-puppet-enterprise-thank-you-all)

extract it

```bash
tar -xzvf puppet-enterprise-3.7.1-el-7-x86_64.tar.gz
```

```bash
cd puppet-enterprise-3.7.1-el-7-x86_64
chmod u+x puppet-enterprise-installer 
./puppet-enterprise-installer
```


### Node

Enable root login

```bash
PermitRootLogin yes
service sshd restart
```

Configure node to connect to master by setting up 'server' in pupppet.conf on node

Check if can connect to master (this also downloads all catalogs if cert is allowed)

```
puppet agent -t
```

Check on master nodes waiting for key

```
puppet cert list
```

Sing one node from master

```
puppet cert sign puppetnode.mydomain.ca
```

Sign all nodes

```
puppet cert sign --all
```

$$123$$

