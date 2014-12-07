## Install steps


Enable root login on nodes

```
PermitRootLogin yes
service sshd restart
```

Setup FQDN on Puppet master

***Do I hardcode to 127.0.0.1 or the IP?? ***


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

