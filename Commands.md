# Commands


#### puppet agent -t

Check if node can connect to master. If the node cert is already authorized on the master, it will download the catalogue and apply.

**Syntax:** `puppet agent -t`

#### puppet cert list

Check on master nodes waiting for key

**Syntax:** `puppet cert list`

Show all know nodes and certificates

**Syntax:** `puppet cert list -a`

#### puppet cert sign

Sign one node from master

**Syntax:** `puppet cert sign [node_hostname]`

Sign all nodes

**Syntax:** `puppet cert sign --all`

#### puppet parser validate

Inspect files for syntax errors (validates DSL syntax). It does not validate resources

**Syntax:** `puppet parser validate [file]`

**Example:**

```bash
# puppet parser validate init.pp 
# echo $?
0

# puppet parser validate groups/wheel.pp 
Error: Could not parse for environment production: Syntax error at ':' at /etc/puppetlabs/puppet/modules/localusers/manifests/groups/wheel.pp:1
```

#### puppet apply --noop

Run catalogue without applying (dry run)

**Syntax:** `puppet apply --noop [file]`

**Example:**

```bash
# puppet apply --noop init.pp 
Notice: Compiled catalog for puppetmaster.mydomain.com in environment production in 0.28 seconds
Notice: /Stage[main]/Localusers/User[admin]/ensure: current_value absent, should be present (noop)
Notice: Class[Localusers]: Would have triggered 'refresh' from 1 events
Notice: Stage[main]: Would have triggered 'refresh' from 1 events
Notice: Finished catalog run in 0.28 seconds
```

#### puppet apply init.pp

Apply catalogue

**Syntax:** `puppet apply [file]`

**Example:**

```bash
# puppet apply init.pp 
Notice: Compiled catalog for 
in environment production in 0.48 seconds
Notice: /Stage[main]/Localusers/User[admin]/ensure: created
Notice: Finished catalog run in 0.58 seconds
```
 