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

#### puppet cert clean 

Delete agent from master

**Syntax:** `puppet cert clean [node]`



## puppet config

This subcommand can inspect and modify settings from Puppet's `puppet.conf` configuration file. 

**Example:** Gets value of `certname`

```bash
puppet config print certname
```

Differences between older `puppet {master|agent|user} --configprint [option]` and `puppet config print [option] --section {master|agent|user}`

```
$ puppet master --configprint ca_name
Puppet CA generated on victorbrca1.mylabserver.com at 2014-12-18 17:42:18 +0000

$ puppet config print ca_name
Puppet CA: victorbrca1.mylabserver.com

$ puppet agent --configprint ca_name
Puppet CA: victorbrca1.mylabserver.com

$ puppet config print ca_name --section master
Puppet CA generated on victorbrca1.mylabserver.com at 2014-12-18 17:42:18 +0000
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

#### puppet apply init.pp

Applies Puppet manifest to the local system using specified file.

**Syntax:** `puppet apply [file]`

**Example:**

```bash
# puppet apply init.pp 
Notice: Compiled catalog for 
in environment production in 0.48 seconds
Notice: /Stage[main]/Localusers/User[admin]/ensure: created
Notice: Finished catalog run in 0.58 seconds
```

#### puppet apply --noop

Run manifest without applying (dry run).

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



## puppet module

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

```
$ puppet module list
/etc/puppetlabs/puppet/modules
├── apache (???)
├── base (???)
├── democonsole (???)
├── filedemo (???)
├── hierademo (???)
├── localusers (???)
├── motd (???)
├── ntp (???)
├── profiles (???)
├── roles (???)
└── sdn (???)
/opt/puppet/share/puppet/modules
├── puppetlabs-apt (v1.5.0)
├── puppetlabs-auth_conf (v0.2.2)
├── puppetlabs-concat (v1.0.3)
├── puppetlabs-firewall (v1.1.2)
├── puppetlabs-inifile (v1.1.0)
├── puppetlabs-java_ks (v1.2.4)
├── puppetlabs-pe_accounts (v2.0.2-3-ge71b5a0)
├── puppetlabs-pe_console_prune (v0.1.1-4-g293f45b)
├── puppetlabs-pe_mcollective (v0.2.10-15-gb8343bb)
├── puppetlabs-pe_postgresql (v1.0.4-4-g0bcffae)
├── puppetlabs-pe_puppetdb (v1.1.1-13-gddf24c2)
├── puppetlabs-pe_razor (v0.2.1-1-g80acb4d)
├── puppetlabs-pe_repo (v0.7.7-32-gfd1c97f)
├── puppetlabs-pe_staging (v0.3.3-2-g3ed56f8)
├── puppetlabs-postgresql (v2.5.0-pe2)
├── puppetlabs-puppet_enterprise (v3.2.1-27-g8f61956)
├── puppetlabs-reboot (v0.1.4)
├── puppetlabs-request_manager (v0.1.1)
└── puppetlabs-stdlib (v3.2.2)
```

## puppet node

This subcommand interacts with node objects, which are used by Puppet to
build a catalog. A node object consists of the node's facts, environment,
node parameters (exposed in the parser as top-scope variables), and classes.

```
USAGE: puppet node <action> [--terminus TERMINUS] [--extra HASH]
```

#### puppet node deactivate

Deactivates node from puppet master.

**Syntax:** `puppet node deactivate [cert]`

## puppet resource

Converts current system state into Puppet code, along with some ability to modify the current state using Puppet's RAL.

If given a type, a name, and a series of `<attribute>=<value>` pairs,
puppet resource will modify the state of the specified resource.

```bash
$ puppet resource user jeff
user { 'jeff':
  ensure           => 'present',
  gid              => '503',
  groups           => ['wheel', 'finance'],
  home             => '/home/jeff',
  password         => '!!',
  password_max_age => '99999',
  password_min_age => '0',
  shell            => '/bin/bash',
  uid              => '503',
}
```

## facter

Collect and display facts about the current system.

```bash
USAGE
=====
    -y, --yaml                       Emit facts in YAML format.
    -j, --json                       Emit facts in JSON format.
        --trace                      Enable backtraces.
        --external-dir DIR           The directory to use for external facts.
        --no-external-dir            Turn off external facts.
    -d, --debug                      Enable debugging.
    -t, --timing                     Enable timing.
    -p, --puppet                     Load the Puppet libraries, thus allowing Facter to load Puppet-specific facts.
    -v, --version                    Print the version and exit.
    -h, --help                       Print this help message.
```