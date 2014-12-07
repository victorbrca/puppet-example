# Resource Types










## Resource Types

#### file

- file - Makes sure it's a normal file
- directory -  Makes sure it's a directory (enables recursive)
- link - Symlink
- absent - Deletes file if it exists

```
class filedemo {
	file { '/root/motd':
		ensure  => present,
		#content => 'this is my motd file managed by content',
		source => 'puppet:///modules/filedemo/motd',
		owner   => root,
		group   => root,
		mode    => '0644',
	}

	file { '/etc/motd':
		ensure => link,
		target => '/root/motd',
	}
}
```

#### User

https://docs.puppetlabs.com/references/latest/type.html#user

```
class localusers {
        user { 'admin':
                ensure     		=> present,
                shell      		=> '/bin/bash',
                home       		=> '/home/admin',
                gid				=> 'wheel',
                managehome		=> true, # ensures that home exists
                password		=> '$6$.D6.L3YN$xElKED4RUc0y89PdUZK0Yd9EjPin7LRP9V105PWeH4orxrd.7gOFUK6P2AtwF/4oV5h.3sKEQpV9oOl.tEmuk1',
        }

        user { 'jeff':
                ensure     => present,
                shell      => '/bin/bash',
                groups     => [ 'wheel', 'finance'],
                managehome => true,
        }
}
```

#### Group

https://docs.puppetlabs.com/references/latest/type.html#group

```
group { 'wheel':
	ensure => present,
	members => 'admin', # Adds user to group instead of doing on user type resource
}
```

*** Note:*** *Assigining a user to a group makes puppet to implicit create a group before adding users*

#### Package

```
package { 'apache':
	ensure => present,
}

# Using an array
package { ['openssh','mysql']:
	ensure => present,
}
```

#### Service

How to make sure that package is installed before?
Service name depending on distro

```
service { 'sshd':
	ensure => running,
	enable => true, # Starts at boot time
}
```

Using factor variable to define a service

```
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







