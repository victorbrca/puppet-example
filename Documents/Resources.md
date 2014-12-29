# Resource Types

#### file

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

**TIP** - Only create the file if it doesn't exist with `replace => no`. This is useful if you are using a `source`, `content` or `file` attribute to create the file, but plan to make modifications to the file manually later. 

```puppet
file { "/tmp/hello-file":
    replace => "no", # this is the important property
    ensure  => "present",
    content => "From Puppet\n",
    mode    => 644,
}
```


#### User

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

#### Group

https://docs.puppetlabs.com/references/latest/type.html#group

```puppet
group { 'wheel':
	ensure => present,
	members => 'admin', # Adds user to group instead of doing on user type resource
}
```

*** Note:*** *Assigining a user to a group makes puppet to implicit create a group before adding users*

#### Package

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

#### Service

https://docs.puppetlabs.com/references/latest/type.html#service

How to make sure that package is installed before?
Service name depending on distro

```puppet
service { 'sshd':
	ensure => running,
	enable => true, # Starts at boot time
}
```

Using factor variable to define a service

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

## Metaparameters

#### require 

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

#### before

https://docs.puppetlabs.com/references/latest/metaparameter.html#before

Apply this before a referenced resource is applyed.

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

#### subscribe

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

#### notify

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

#### Other Metaparameters

- **alias** - Creates an alias for a resource name
- **audit** - Checks if an attribute for resource has changed since last run
- **noop** - Tells the resource not to execute
- **loglevel** - Valid values are debug, info, notice, warning, err, alert, emerg, crit, verbose.
- **tag** - Sets a tag for a resource (can be used to execute resources with specific tags)


## Resource Execution and Ordering

- Puppet doesn't apply the catalog in a specific order
- You can use metaparameters (requires, before) to order how a catalog is applied
- When using multiple notify for the same resource, Puppet will only restart a service once