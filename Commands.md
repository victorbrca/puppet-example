# Commands


#### puppet agent -t

Check if node can connect to master (this also downloads all catalogs if cert is allowed)

```
puppet agent -t
```

#### puppet cert list

Check on master nodes waiting for key

```
puppet cert list
```

Show all know nodes and certificates

```
puppet cert list -a
```

#### puppet cert sign

Sign one node from master

```
puppet cert sign [node_hostname]
```

Sign all nodes

```
puppet cert sign --all
```

#### puppet parser validate

Inspect files for syntax errors (validates DSL syntax). It does not validate resources

```
puppet parser validate [file]
```

```
# puppet parser validate init.pp 
# echo $?
0

# puppet parser validate groups/wheel.pp 
Error: Could not parse for environment production: Syntax error at ':' at /etc/puppetlabs/puppet/modules/localusers/manifests/groups/wheel.pp:1
```

#### puppet apply --noop

Run catalogue without applying (dry run)

`puppet apply --noop [file]`

```
# puppet apply --noop init.pp 
Notice: Compiled catalog for puppetmaster.mydomain.com in environment production in 0.28 seconds
Notice: /Stage[main]/Localusers/User[admin]/ensure: current_value absent, should be present (noop)
Notice: Class[Localusers]: Would have triggered 'refresh' from 1 events
Notice: Stage[main]: Would have triggered 'refresh' from 1 events
Notice: Finished catalog run in 0.28 seconds
```

#### puppet apply init.pp

Apply catalogue

`# puppet apply [file]`

```
# puppet apply init.pp 
Notice: Compiled catalog for 
in environment production in 0.48 seconds
Notice: /Stage[main]/Localusers/User[admin]/ensure: created
Notice: Finished catalog run in 0.58 seconds
```
 