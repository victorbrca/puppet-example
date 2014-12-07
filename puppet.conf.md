# Puppet Config File (puppet.conf)

[Configuration Reference](https://docs.puppetlabs.com/references/3.7.latest/configuration.html)

**Location (Puppet open source)** = /etc/puppet.conf

Configuraton from file is loaded at start time. So changes made here require a restart of the service (either master or agent)

## Sections

### `[main]` 

Global settings used by all services/servers and is over ridden by other sections 

#### logdir

The Puppet log directory. The default value is '$vardir/log'.

`logdir = /var/log/puppet` 

#### rundir
Where Puppet PID files are kept. The default value is '$vardir/run'.

`rundir = /var/run/puppet`

#### ssldir

Where SSL certificates are kept. The default value is '$confdir/ssl'.

`ssldir = $vardir/ssl`

#### basemodulepath

## ?

### `[master]`

Used by puppet master and puppet cert command

#### dns_alt_names

The comma-separated list of alternative DNS names to use for the local host.

`dns_alt_names = puppetmaster,puppetmaster.mydomain.ca`

#### default_manifest

Use the default_manifest setting to either change the default per-environment manifest or set a global manifest to be used by all environments.

`default_manifest = `

#### CA Settings

#### certname

`certname = puppetmaster.mydomain.ca`

#### ca

Whether the master should function as a certificate authority.

`ca = true`

#### ca_ttl

The default TTL for new certificates. This setting can be a time interval in seconds (30 or 30s), minutes (30m), hours (6h), days (2d), or years (5y).

`ca_ttl = 5y`

#### autosign

Whether (and how) to autosign certificate requests. This setting is only relevant on a puppet master acting as a certificate authority (CA). Default: $confdir/autosign.conf

`autosign = true`

### `[agent]` 

Used by puppet agent, even if runs on master

#### classfile

The file in which puppetd stores a list of the classes associated with the retrieved configuratiion.  Can be loaded in the separate puppet executable using the `--loadclasses` option. The default value is '$confdir/classes.txt'.

`classfile = $vardir/classes.txt`

#### localconfig

Where puppetd caches the local configuration.  An extension indicating the cache format is added automatically. The default value is '$confdir/localconfig'.
    
`localconfig = $vardir/localconfig`

#### ca_server

Server (hostname) used for certificate authority request

`ca_server = puppetmaster.mydomain.ca`

#### server

The puppet master server (hostname) to which the puppet agent should connect.

`server = puppetmaster.mydomain.ca`

#### certname

Certname to use when communicating with the server

`certname = puppetmaster.mydomain.ca`

#### report

Whether to send reports after every transaction.

`report = true`

### `[user]` 
Used most commonly by the puppet apply command


## Editing with Commands

Options can also be added with `puppet config set`. For example, the command below enables report to false under the agent section

```
puppet config set report false --section agent
```