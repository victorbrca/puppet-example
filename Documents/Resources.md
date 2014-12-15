# Resources

[Language: Resources](https://docs.puppetlabs.com/puppet/latest/reference/lang_resources.html)

## Resource Types

[Type Reference](https://docs.puppetlabs.com/references/latest/type.html)

Resources define types and attributes of desired state to puppet.  

Puppet then passes that information to a provider, which will vary depending on your system.

Each resource describes some aspect of a system, like a service that must be running or a package that must be installed. The block of Puppet code that describes a resource is called a resource declaration.

**Syntax**

```puppet
type {'resource title|name':
    attribute => 'attribute value',
}
```

For example, this will use the appropriate package manager depending on Debian (apt) or RedHat (RPM) system to make sure that openssh is installed:

```
package { 'openssh':
  ensure  => installed,
  alias   => openssh,
  require => Package[openssl]
}
```

### Type: file

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

Setting file attribute for many files (file defaulst) and overriding the group

```puppet
File {
    owner => 'root',
    group => 'finance',
    mode  => '660',
}
            
file { '/etc/motd':
    ensure => present,
    group  => 'root',
}

```

***Note:*** When using "source => puppet:///" the files should be readable by the remote user to download the file. Usually set it to '644'.

### Type: user

https://docs.puppetlabs.com/references/latest/type.html#user

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

**Example 2**

```puppet
user { 'jeff':
	ensure		=> present,
	shell		=> '/bin/bash',
	groups		=> [ 'wheel', 'finance'],
	managehome	=> true,
}
```

### Type: group

https://docs.puppetlabs.com/references/latest/type.html#group

```puppet
group { 'wheel':
	ensure => present,
	members => 'admin', # Adds user to group instead of doing on user type resource
}
```

*** Note:*** *Assigining a user to a group makes puppet to implicit create a group before adding users*

### Type: package

https://docs.puppetlabs.com/references/latest/type.html#package

```puppet
package { 'apache':
	ensure => present,
}

# Using an array
package { ['openssh','mysql']:
	ensure => present,
}
```

### Type: service

https://docs.puppetlabs.com/references/latest/type.html#service

```puppet
service { 'sshd':
	ensure => running,
	enable => true, # Starts at boot time
}
```

Using factor variable to define a service based on distro

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

### Type: schedule

Execute a system update when puppet agent runs between 12am-1am

```puppet
$systemupdate = $osfamily ? {
    'RedHat' => '/usr/bin/yum update -y',
    'Debian' => '/usr/bin/apt-get upgrade -y',
}

schedule { 'system-daily':
    period => daily,
    range  => '00:00 - 01:00',
}

exec { $systemupdate:
    schedule => 'system-daily',
}
```

## Metaparameters

### require 

https://docs.puppetlabs.com/references/latest/metaparameter.html#require

Require the named resource to exist

**Example (require)**

This makes sure that the 'ssh' package is installed before the service is started. Note the capital 'P' when referencing the resource (package name).

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

### before

https://docs.puppetlabs.com/references/latest/metaparameter.html#before

Apply this before a referenced resource is applied.

**Example (before)**

Makes sure that the package is present before starting the service. Note the capital 'S' when refering the service. 

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

### subscribe

https://docs.puppetlabs.com/references/latest/metaparameter.html#subscribe

Listen to puppet changes on referenced resource

**Example (subscribe)**

Restarts the sshd service whenever puppet changes '/etc/ssh/sshd_config'.

```puppet
file { '/etc/ssh/sshd_config':
	ensure	=> present,
	source	=> 'puppet:///modules/ssh/ssh_config',
}

service { 'sshd':
	ensure	=> running,
	enable	=> true,
	subscribe	=> File['/etc/ssh/sshd_config'],
}
```

### notify

https://docs.puppetlabs.com/references/latest/metaparameter.html#notify

Sends a notification when puppet changes the resource

**Example (notify)**

Sends a notify (restart) to the service 'sshd' whenever '/etc/ssh/sshd_config' changes

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

### Other Common Metaparameters

- **alias** - Creates an alias for a resource name. Can be used to refer to a resource name instead of it's real name
- **audit** - Checks if an attribute for resource has changed since last run
- **noop** - Tells the resource not to execute
- **loglevel** - Valid values are debug, info, notice, warning, err, alert, emerg, crit, verbose.
- **tag** - Sets a tag for a resource (can be used to execute resources with specific tags)


## Arrays

Examples:

```puppet
user { 'jeff':
	ensure => present,
	groups => [ 'wheel', 'finance'],
}
```

```puppet
package { ['openssh','mysql']:
	ensure => present,
}
```













