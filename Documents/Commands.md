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

## Resources

List all resource types available

```
# puppet describe -l
These are the types known to puppet:
anchor          - A simple resource type intended to be used as ...
apt_key         - This type provides Puppet with the capabiliti ...
augeas          - Apply a change or an array of changes to the  ...
computer        - Computer object management using DirectorySer ...
cron            - Installs and manages cron jobs
exec            - Executes external commands
file            - Manages files, including their content, owner ...
file_line       - Ensures that a given line is contained within ...
filebucket      - A repository for storing and retrieving file  ...
firewall        - This type provides the capability to manage f ...
firewallchain   - This type provides the capability to manage r ...
group           - Manage groups
host            - Installs and manages host entries
ini_setting     - .. no documentation ..
ini_subsetting  - .. no documentation ..
interface       - This represents a router or switch interface
java_ks         - Manages entries in a java keystore
k5login         - Manage the `.k5login` file for a user
macauthorization - Manage the Mac OS X authorization database
mailalias       - .. no documentation ..
maillist        - Manage email lists
mcx             - MCX object management using DirectoryService  ...
mount           - Manages mounted filesystems, including puttin ...
nagios_command  - The Nagios type command
nagios_contact  - The Nagios type contact
nagios_contactgroup - The Nagios type contactgroup
nagios_host     - The Nagios type host
nagios_hostdependency - The Nagios type hostdependency
nagios_hostescalation - The Nagios type hostescalation
nagios_hostextinfo - The Nagios type hostextinfo
nagios_hostgroup - The Nagios type hostgroup
nagios_service  - The Nagios type service
nagios_servicedependency - The Nagios type servicedependency
nagios_serviceescalation - The Nagios type serviceescalation
nagios_serviceextinfo - The Nagios type serviceextinfo
nagios_servicegroup - The Nagios type servicegroup
nagios_timeperiod - The Nagios type timeperiod
notify          - .. no documentation ..
package         - Manage packages
pe_postgresql_conf - .. no documentation ..
pe_postgresql_psql - .. no documentation ..
pe_puppetdb_conn_validator - Verify that a connection can be successfully  ...
postgresql_psql - .. no documentation ..
reboot          - Manages system reboots
resources       - This is a metatype that can manage other reso ...
router          - .. no documentation ..
schedule        - Define schedules for Puppet
scheduled_task  - Installs and manages Windows Scheduled Tasks
selboolean      - Manages SELinux booleans on systems with SELi ...
selmodule       - Manages loading and unloading of SELinux poli ...
service         - Manage running services
ssh_authorized_key - Manages SSH authorized keys
sshkey          - Installs and manages ssh host keys
stage           - A resource type for creating new run stages
tidy            - Remove unwanted files based on specific crite ...
user            - Manage users
vlan            - .. no documentation ..
whit            - Whits are internal artifacts of Puppet's curr ...
yumrepo         - The client-side description of a yum reposito ...
zfs             - Manage zfs
zone            - Manages Solaris zones
zpool           - Manage zpools
```

View a specific resource type

```
# puppet resource [type] {name}

# puppet resource file /etc/motd
file { '/etc/motd':
  ensure  => 'file',
  content => '{md5}015dbbe0c5775914e8836cbb0c809f32',
  ctime   => 'Mon Dec 01 04:27:55 +0000 2014',
  group   => '0',
  mode    => '644',
  mtime   => 'Mon Dec 01 04:27:55 +0000 2014',
  owner   => '0',
  type    => 'file',
}

```
 