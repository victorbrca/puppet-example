# Commands

## puppet agent

Retrieves the client configuration from the puppet master and applies it to the local host.

This service may be run as a daemon, run periodically using cron (or something similar), or run interactively for testing purposes.

```
USAGE
-----
puppet agent [--certname <name>] [-D|--daemonize|--no-daemonize]
  [-d|--debug] [--detailed-exitcodes] [--digest <digest>] [--disable [message]] [--enable]
  [--fingerprint] [-h|--help] [-l|--logdest syslog|<file>|console]
  [--no-client] [--noop] [-o|--onetime] [-t|--test]
  [-v|--verbose] [-V|--version] [-w|--waitforcert <seconds>]
```

#### Common Used Options

- --disable:
  Disable working on the local system. This puts a lock file in place,
  causing 'puppet agent' not to work on the system until the lock file
  is removed
  
- --enable:
  Enable working on the local system. This removes any lock file,
  causing 'puppet agent' to start managing the local system again
  (although it will continue to use its normal scheduling, so it might
  not start for another half hour)
  
- --onetime (-o):
  Run the configuration once. Runs a single (normally daemonized) Puppet
  run. Useful for interactively running puppet agent when used in
  conjunction with the --no-daemonize option.

- --no-daemonize:
  Do not send the process into the background.

- --test (-t):
  Enable the most common options used for testing. These are 'onetime'



## puppet cert

Manage certificates and requests. Capable of generating certificates,
but mostly used for signing certificate requests from puppet clients.

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

## puppet config

This subcommand can inspect and modify settings from Puppet's `puppet.conf` configuration file. 

**Example:** Gets value of `certname`

```bash
puppet config print certname
```

## puppet parser

Interact directly with the parser.

#### puppet parser validate

Inspect files for syntax errors (validates DSL syntax). It does not validate resources.

**Syntax:** `puppet parser validate [file]`

**Example:**

```bash
# puppet parser validate init.pp 
# echo $?
0

# puppet parser validate groups/wheel.pp 
Error: Could not parse for environment production: Syntax error at ':' at /etc/puppetlabs/puppet/modules/localusers/manifests/groups/wheel.pp:1
```

## puppet apply

Applies a standalone Puppet manifest to the local system.

#### puppet apply --noop

Run catalogue without applying (dry run).

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

# puppet module

Find, install, and manage modules from the Puppet Forge,
a repository of user-contributed Puppet code. It can also generate empty
modules, and prepare locally developed modules for release on the Forge.

```
ACTIONS:
  build        Build a module release package.
  changes      Show modified files of an installed module.
  generate     Generate boilerplate for a new module.
  install      Install a module from the Puppet Forge or a release archive.
  list         List installed modules
  search       Search the Puppet Forge for a module.
  uninstall    Uninstall a puppet module.
  upgrade      Upgrade a puppet module.
```
