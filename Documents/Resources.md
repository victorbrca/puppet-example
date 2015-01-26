Resource Types And Metaparameters
=================================

Resources
---------

[Type Reference](https://docs.puppetlabs.com/references/latest/type.html)

Resources are a fundamental part of Puppet. Each resource describes some aspect of a system, like a service that must be running or a package that must be installed.

The block of Puppet code that describes a resource is called a resource declaration.

#### Resource Execution and Ordering

- Puppet doesn't apply the catalog in a specific order
- You can use metaparameters (requires, before) to order how a catalog is applied
- When using multiple notify for the same resource, Puppet will only restart a service once

#### Resource Name (Title)

- Two resources of the same type cannot have the same title, however different resource types can, because puppet refers to them as `type[title]`. For example, `File[httpd]` for the httpd config, and `Package[httpd]` for the httpd package. 
- Puppet parser validate does not check for resource names or resource validation, only syntax
- Resource names are case sensitive. So `file { 'motd':` is different than `file { 'Motd':`.

### Most Used Recourse Types

#### File

[Type Reference - file](https://docs.puppetlabs.com/references/latest/type.html#file)

- file - Makes sure it's a normal file
- directory -  Makes sure it's a directory (enables recursive)
- link - Symlink
- absent - Deletes file if it exists

```puppet
file { '/root/motd':
	ensure		=> present,
	#content	=> 'this is my motd file managed by content',
	source		=> 'puppet:///modules/filedemo/motd',
	owner		=> root,
	group		=> root,
	mode		=> '0644',
}

file { '/etc/motd':
	ensure	=> link,
	target	=> '/root/motd',
}
```

***Note:*** When using "source => puppet:///" the files should be readable by the remote user to download the file. Usually set it to '644'.

**Tip 1** - Only create the file if it doesn't exist with `replace => no`. This is useful if you are using a `source`, `content` or `file` attribute to create the file, but plan to make modifications to the file manually later. 

```puppet
file { "/tmp/hello-file":
    replace => "no", # this is the important property
    ensure  => "present",
    content => "From Puppet\n",
    mode    => 644,
}
```

**Tip 2** - Create folder and subfolders

Use the `recurse` attribute to get the same results as `mkdir -p`

```puppet
file { '/var/www/html':
    ensure => directory,
	recurse => true,
}
```

**Tip 3** - When using `recurse` with a source, by default it will not overwrite files not managed by puppet (this can be changed with `purge => true`)

```puppet
file { 'upload_sdns':
	name    => '/apps/scope/cb/DeploymentDirector/updates',
	ensure  => directory,
	owner   => 'cbadmin',
	group   => 'cbadmin',
	source  => "puppet:///sdns/2011/CB",
	recurse => true,
}
```

**Tip 4** - Use `exec` to only create a file if it exists

```puppet
exec { 'check_sdn_folder':
    command => '/bin/true',
    onlyif => '/usr/bin/test -d /apps/scope/cb/DeploymentDirector/updates',
}

file { 'upload_sdns':
	name    => '/apps/scope/cb/DeploymentDirector/updates',
	ensure  => directory,
	require => Exec['check_sdn_folder'],
}
```

#### User

[Type Reference - user](https://docs.puppetlabs.com/references/latest/type.html#user)

**Example 1**

```puppet
 user { 'admin':
    ensure     		=> present,
    shell      		=> '/bin/bash',
    home       		=> '/home/admin',
    gid				=> 'wheel',
    managehome		=> true, # ensures that home exists
    password		=> '$6$.D6.L3YN$xElKED4RUc0y89PdUZK0Yd9EjPin7LRP9V105PWeH4orxrd.7gOFUK6P2AtwF/4oV5h.3sKEQpV9oOl.tEmuk1',
}
```

**Example 2:** Using an array for the groups

```puppet
user { 'jeff':
	ensure		=> present,
	shell		=> '/bin/bash',
	groups		=> [ 'wheel', 'finance'],
	managehome	=> true,
}
```

#### Group

[Type Reference - group](https://docs.puppetlabs.com/references/latest/type.html#group)

Manages and creates groups.

```puppet
group { 'wheel':
	ensure => present,
	members => 'admin', # Adds user to group instead of doing on user type resource
}
```

***Note:*** Assigining a user to a group makes puppet to implicit create a group before adding users's

#### Package

[Type Reference - group](https://docs.puppetlabs.com/references/latest/type.html#package)

Manages OS packages (apache, samba, vim, etc...) via default package manager (apt, yum, zypper, etc...).

Package names may vary depending on distro, so you have to be aware of that.

```puppet
package { 'apache':
	ensure => present,
}

# Using an array
package { ['openssh','mysql']:
	ensure => present,
}
```

#### Service

[Type Reference - service](https://docs.puppetlabs.com/references/latest/type.html#service)

Manages running services. You can make so puppet checks that the package for the service is isntalled, and even restart the service should a config file changes.

Service names may vary depending on distro, so you have to be aware of that.

**Example 1**

```puppet
service { 'sshd':
	ensure => running,
	enable => true, # Starts at boot time
}
```

**Example 2: **Using factor variable to define a service name based on OS

```puppet
case $osfamily {
	'RedHat': {
		$ssh_name = ' sshd'
	}
	'Debian': {
		$ssh_name = ' ssh'
	}
	'default': {
		Warning('OS family does not match')
	}

	service { 'resource-name':
		name => $ssh_name,
		ensure => running,
		enable => true,
	}
}
```

**Example 3:** Restart the service when the config file changes with `notify`

```puppet
service { 'sshd':
	ensure => running,
	enable => true,
}

file { 'sshd-config':
    name    => '/etc/ssh/sshd_config',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/base/sshd_config',
    notify  => Service['sshd'],
}
```

#### Exec

[Type Reference - exec](http://docs.puppetlabs.com/references/latest/type.html#exec)

Executes external commands (external to puppet).

By default, exec is no idempotent, however it can be made so with the use of:
- The command (apt-get is idempotent)
- With on of the attributes `onlyif`, `unless` or `creates`
- The exec has `refreshonly => true`, which only allows Puppet to run the command when some other resource is changed

Exec should only be used for simple tasks.

**Example 1:** Only add the string `Welcome to the system` to `/etc/motd` if it doesn't already exists

```puppet
exec { "echo Welcome to the system >> /etc/motd":
	path   => "/bin:/usr/bin",
	onlyif => "test -z `grep Welcome /etc/motd`",
}
```

**Example 2: **Checking if .bashrc is managed by puppet. If false, remove it

```puppet
# Let's check if .bashrc exists and is managed by puppet
exec { 'check_bashrc':
	command => '/bin/grep -q puppet /home/jeff/.bashrc || /bin/rm -rf /home/jeff/.bashrc',
	user    => 'jeff',
}
```

#### Host

[Type Reference - exec](http://docs.puppetlabs.com/references/latest/type.html#host)

Installs and manages host entries.

```puppet
class practice {

	host { 'webserver01':
		name         => 'webserver01.mylabserver.com',
		ip           => '10.1.1.1',
		host_aliases => ['web01','webhead01','webserver1'],
		comment	     => "This s our webserver primary",
	}

}
```

**Notes:**
- Removing a comment on the resource configuration will not remove the comment from the resource
- It adds a header to the hosts file as shown below

```
# HEADER: This file was autogenerated at 2015-01-12 02:20:02 +0000
# HEADER: by puppet.  While it can still be managed manually, it
# HEADER: is definitely not recommended.
```

Metaparameters
---------------

Some attributes in Puppet can be used with every resource type. These are called metaparameters. They don’t map directly to system state; instead, they specify how Puppet should act toward the resource.

The most commonly used metaparameters are for specifying order relationships between resources.

#### require

[Metaparameter Reference - require](https://docs.puppetlabs.com/references/latest/metaparameter.html#require)

Require the named resource to exist.

**Example:** This makes sure that the 'ssh' package is installed before the service is started. Note the capital 'P' when referencing the resource (package name).

```puppet
package { 'ssh':
	name	=> 'openssh',
	ensure	=> present,
}

service { 'sshd':
	ensure	=> running,
	enable	=> true,
	require	=> Package['ssh'],
}
```

#### before

[Metaparameter Reference - require](https://docs.puppetlabs.com/references/latest/metaparameter.html#before)

Apply this before a referenced resource is applyed.

**Example:** Makes sure that the package is present before starting the service. Note the capital 'S' when refering the service. 

```puppet
package { 'ssh-package':
	ensure	=> present,
	before	=> Service['sshd'],
}

service { 'sshd':
	ensure	=> running,
	enable	=> true,
}
```

#### subscribe

[Metaparameter Reference - require](https://docs.puppetlabs.com/references/latest/metaparameter.html#subscribe)

Listen to puppet changes on referenced resource.

**Example:** Restarts the sshd service whenever puppet changes '/etc/ssh/sshd_config'

```puppet
file { '/etc/ssh/sshd_config':
	ensure	=> present,
	source	=> 'puppet:///modules/ssh/ssh_config',
}

service { 'sshd':
	ensure	  => running,
	enable	  => true,
	subscribe => File['/etc/ssh/sshd_config'],
}
```

#### notify

[Metaparameter Reference - require](https://docs.puppetlabs.com/references/latest/metaparameter.html#notify)

Sends a notification when puppet changes the resource.

**Example:** Sends a notify (restart) to the service 'sshd' whenever '/etc/ssh/sshd_config' changes

```puppet
file { '/etc/ssh/sshd_config':
	ensure	=> present,
	source	=> 'puppet:///modules/ssh/ssh_config',
	notify	=> Service['sshd'],
}

service { 'sshd':
	ensure	=> running,
	enable	=> true,
}
```

#### Other Metaparameters

- **alias** - Creates an alias for a resource name
- **audit** - Checks if an attribute for resource has changed since last run
- **noop** - Tells the resource not to execute
- **loglevel** - Valid values are debug, info, notice, warning, err, alert, emerg, crit, verbose.
- **tag** - Sets a tag for a resource (can be used to execute resources with specific tags)


